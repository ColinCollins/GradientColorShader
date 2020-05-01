Shader "Custom/FDLineGradient"
{
	Properties
	{
		_ColorCount("Number of Colors", int) = 5
		_Angle("Angle", float) = 0
	}

		SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" }
		Cull Off

		Pass {

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog

			#include "UnityCG.cginc"
			#define DEGREE_2_RADIAN 0.01745329252

			struct appdata
			{
				float4 vertex: POSITION;
				float2 texcoord: TEXCOORD0;
			};

			struct v2f
			{
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			float _Angle;
			int _ColorCount;
			fixed4 _GradientColors[5];
			float _GradientPositions[5];

			// back color
			fixed4 sampleGradientColor(fixed4 colors[5], float positions[5], float y)
			{
				for (int i = 0; i < _ColorCount; i++)
				{
					if (y <= positions[i])
					{
						if (i == 0)
						{
							return colors[0];
						}
						else
						{
						   return lerp(colors[i - 1], colors[i], (y - positions[i - 1]) / (positions[i] - positions[i - 1]));
						}
					}
					else if (i == _ColorCount - 1)
					{
						return colors[i];
					}
				}

				return fixed4(0, 0, 0, 0);
			}

			float2 rotateUV(fixed2 uv, float rotation) 
			{
				float sinX = sin(rotation);
				float cosX = cos(rotation);
				float2x2 rotationMatrix = float2x2(cosX, -sinX, sinX, cosX);

				// 旋转 uv 角度
				return mul(uv - fixed2(0.5, 0.5), rotationMatrix) + fixed2(0.5, 0.5);
			}

			v2f vert(appdata v)
			{
			   v2f o;
			   UNITY_SETUP_INSTANCE_ID(v);
			   // ???
			   UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			   o.vertex = UnityObjectToClipPos(v.vertex);
			   o.texcoord = v.texcoord;
			   return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 rotatedUV = rotateUV(i.texcoord, _Angle * DEGREE_2_RADIAN);
			   return sampleGradientColor(_GradientColors, _GradientPositions, rotatedUV.y);
			}

			ENDCG
	   }
	}

    FallBack "Diffuse"
}
