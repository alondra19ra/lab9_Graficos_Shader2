Shader "Unlit/Ejercicio6"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _ScrollDir("Scroll Direction (X,Y)", Vector) = (1, 0, 0, 0)
        _Speed("Scroll Speed", Range(0,10)) = 1
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

                float2 _ScrollDir;   // Dirección del desplazamiento
                float _Speed;        // Velocidad del desplazamiento

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    // Aplica tiling/offset estándar
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // Calcula el desplazamiento según el tiempo global
                    float2 scrolledUV = i.uv + _ScrollDir * _Speed * _Time.y;

                    // Muestra la textura desplazada
                    fixed4 col = tex2D(_MainTex, scrolledUV);

                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col;
                }
                ENDCG
            }
        }
}
