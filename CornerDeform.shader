Shader "Unlit/ExampleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;

            uniform float _animationSpeed;
            uniform float _animationPower;
            uniform float _distanceToCenterSupport;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normals : TEXCOORD1;
            };

            float2 GetCenteredUV(float2 uvToCenter)
            {
                uvToCenter.x *= 2;
                uvToCenter.x -= 1;
                uvToCenter.y *= 2;
                uvToCenter.y -= 1;
                return uvToCenter;
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = v.vertex;
                o.uv = v.uv;
                o.normals = v.normals;

                o.uv = GetCenteredUV(o.uv);
                o.vertex.xyz += v.normals * pow(length(o.uv), 3) * _animationPower * -abs(sin(_Time.y * _animationSpeed));
                
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv = TRANSFORM_TEX(o.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float GetDistanceToCenter(float2 UVs)
            {
                return length(UVs);
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                float distanceToCenter = GetDistanceToCenter(i.uv);
                distanceToCenter += _distanceToCenterSupport * 1/ pow(distanceToCenter,0.5);
                
                fixed4 returningColor = fixed4(1 * distanceToCenter/2, 1 * distanceToCenter/3,1 * distanceToCenter/1, 1);
                
                return returningColor;
                return col;
            }
            ENDCG
        }
    }
}
