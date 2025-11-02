Shader "Unlit/Ejercicio11"
{
    Properties
    {
        _MainTex("Texture A", 2D) = "white" {}
        _TexB("Texture B", 2D) = "black" {}
        _Blend("Blend Factor", Range(0,1)) = 0.5
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
                    float2 uvA : TEXCOORD0; // UV para _MainTex
                    float2 uvB : TEXCOORD1; // UV para _TexB
                    UNITY_FOG_COORDS(2)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;

                sampler2D _TexB;
                float4 _TexB_ST;

                float _Blend;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);

                    // Aplica tiling/offset independiente para cada textura
                    o.uvA = TRANSFORM_TEX(v.uv, _MainTex);
                    o.uvB = TRANSFORM_TEX(v.uv, _TexB);

                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // Muestra ambas texturas con sus UV respectivas
                    fixed4 colA = tex2D(_MainTex, i.uvA);
                    fixed4 colB = tex2D(_TexB, i.uvB);

                    // Mezcla entre ambas texturas
                    fixed4 col = lerp(colA, colB, _Blend);

                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col;
                }
                ENDCG
            }
        }
}
