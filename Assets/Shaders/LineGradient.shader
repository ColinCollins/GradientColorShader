Shader "Custom/LineGradient"
{
	Properties
	{
		_ColorCount ("Number of Colors", int) = 5
		_Angle ("Angle", float) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True"}
		Cull Off

		Pass {

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog

			#include "UnityCG.cginc"

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

			 // back color
			 fixed4 sampleGradientColor(fixed4 colors[5], float positions[5], int count, float y)
			 {
				 for (int i = 0; i < count; i++)
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
					 else if (i == count - 1)
					 {
						 return colors[i];
					 }
				 }

				 return fixed4(0, 0, 0, 0);
			 }

			 float _Angle;
			 int _ColorCount;
			 fixed4 _GradientColors[5];
			 float _GradientPositions[5];

			 v2f vert (appdata v)
			 {
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				// ???
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			 }

			 fixed4 frag (v2f i) : SV_Target
			 {
				return sampleGradientColor(_GradientColors, _GradientPositions, _ColorCount, i.texcoord.y);
			 }

			 ENDCG
		}
	}
		FallBack "Diffuse"
}
