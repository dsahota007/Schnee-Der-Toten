Shader "Custom/BlackWhiteShader"
{
    Properties
    {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _Threshold ("Threshold", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Threshold;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                float grayscale = dot(color.rgb, float3(0.299, 0.587, 0.114));
                float bw = grayscale > _Threshold ? 1.0 : 0.0;
                return fixed4(bw, bw, bw, color.a);
            }
            ENDCG
        }
    }
}
