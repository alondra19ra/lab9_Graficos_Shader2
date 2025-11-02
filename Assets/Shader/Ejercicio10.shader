Shader "Unlit/Ejercicio10"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _VignetteColor("Vignette Color", Color) = (0,0,0,1)
        _Intensity("Vignette Intensity", Range(0,1)) = 0.5
        _Power("Vignette Power", Range(0.1,5)) = 2.0
    }

        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;

                fixed4 _VignetteColor;
                float _Intensity;
                float _Power;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // Muestrea el color base de la textura
                    fixed4 col = tex2D(_MainTex, i.uv);

                // Calcula distancia del pixel al centro de la pantalla UV (0.5,0.5)
                float2 center = float2(0.5, 0.5);
                float dist = distance(i.uv, center);

                // Calcula el factor de viñeta con potencia y suavidad
                float vignetteFactor = pow(saturate(dist * 2.0), _Power);

                // Mezcla entre color original y color de viñeta según intensidad
                col.rgb = lerp(col.rgb, _VignetteColor.rgb, vignetteFactor * _Intensity);

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
        }
}
