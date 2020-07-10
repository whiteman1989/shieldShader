Shader "CookbookShaders/Field" {
	Properties {
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		_ShieldColor("Shield Color", Color) = (1,1,1,1)
		_Transparence("Transparence", Range(0,1)) = 1.0
		_RimValue ("Rim value", Range (0,1)) = 0.5
		_ScrollXSpeed ("X Scroll Speed", Range(-5, 5)) = 0
		_ScrollYSpeed ("Y Scroll Speed", Range(-5, 5)) = 0
		_ShieldAlfa("Shield Alfa" , 2D) = "white" 

	}
	SubShader {
		Tags {
		"Queue"="Transparent"
		"RenderType"="Transparent"
		"IgnoreProjector"="True"
		"ForceNoShadowCasting"="True"
		}
		
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Field alpha

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _ShieldAlfa;

		struct Input {
			float2 uv_ShieldAlfa;
		};

		float4 _EmissiveColor;
		float4 _ShieldColor;
		float _Transparence;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
		fixed _RimValue;
		


		inline float4 LightingField(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float rimLight = dot(s.Normal, viewDir);
			float hRim = 1 - abs(rimLight);//rimLight * 0.5 + 0.5;
			float4 col;

			col.rgb = s.Albedo * _EmissiveColor.rgb;
			col.a = s.Alpha * (hRim*hRim*_RimValue);
			return col;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed varX = _ScrollXSpeed * _Time;
			fixed varY = _ScrollYSpeed * _Time;
			fixed2 uv_Tex = IN.uv_ShieldAlfa + fixed2(varX, varY);
			fixed3 texColor = tex2D(_ShieldAlfa, uv_Tex).rgb;
			o.Albedo = _ShieldColor;
			o.Alpha = texColor.b * _Transparence;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
