Shader "Custom/FDGradientAngle"
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
            #define DOUBLE_PI 6.2831853072
            #define INVERSE_DOUBLE_PI 0.1591549431

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

			int _ColorCount;
			fixed4 _GradientColors[5];
			float _GradientPositions[5];

			float _CenterX;
			float _CenterY;
            float _ScaleX;
            float _ScaleY;

            float angleOf (float2 vec)
            {
                if (vec.x == 0 && vec.y == 0)
                    return 0;

                float d = sqrt(vec.x * vec.x + vec.y * vec.y);
                if (vec.y > 0)
                {
                    return acos(vec.x / d);
                }
                else
                {
                    return DOUBLE_PI - acos(vec.x / d);
                }
            }

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

			v2f vert(appdata v)
			{
			   v2f o;
			   UNITY_SETUP_INSTANCE_ID(v);
			   UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

			   o.vertex = UnityObjectToClipPos(v.vertex);
			   o.texcoord = v.texcoord;
			   return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 uv = i.texcoord;
                // scaleX, scaleY -> X / Y -> aspect
                float2 scale = float2(_ScaleX, _ScaleY);

                float2 d = float2((_CenterX - uv.x) * scale.x / scale.y, _CenterY - uv.y);
                float angle = angleOf(d);

				return sampleGradientColor(_GradientColors, _GradientPositions, angle * INVERSE_DOUBLE_PI);
			}

			ENDCG
	   }
	}

		FallBack "Diffuse"
}
