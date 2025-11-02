Shader "Unlit/Ejercicio12"
{
    Properties
    {
        _MainTex("Base Texture", 2D) = "white" {}
        _DetailTex("Detail Texture", 2D) = "gray" {}
        _DetailBlend("Detail Blend", Range(0,1)) = 0.5
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
                    float2 uvMain : TEXCOORD0;
                    float2 uvDetail : TEXCOORD1;
                    UNITY_FOG_COORDS(2)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;

                sampler2D _DetailTex;
                float4 _DetailTex_ST;

                float _DetailBlend;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);

                    // Aplica tiling/offset independiente
                    o.uvMain = TRANSFORM_TEX(v.uv, _MainTex);
                    o.uvDetail = TRANSFORM_TEX(v.uv, _DetailTex);

                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // Muestrea ambas texturas
                    fixed4 baseCol = tex2D(_MainTex, i.uvMain);
                    fixed4 detailCol = tex2D(_DetailTex, i.uvDetail);

                    // Calcula overlay multiplicativo con control
                    fixed3 overlay = lerp(baseCol.rgb, baseCol.rgb * detailCol.rgb * 2.0, _DetailBlend);

                    fixed4 col = fixed4(overlay, baseCol.a);

                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col;
                }
                ENDCG
            }
        }
}