// This section allows for easy sorting for our shader in the shader menu
Shader "Lesson/Normal Albedo Colour Tint Fog"
{
	// Properties are the public Properties on a material
	Properties
	{
		_Texture("Texture",2D) = "black"{}
		// Our varible name is _Texture
		// Our display name is Texture
		// It is of type 2D and the default untextured colour is black
		_NormalMap("Normal",2D) = "bump"{}
		// Uses RGB colour value to create x, y, z depth to the material
		// Bump tells unity this material needs to be marked as a normal map
		// So that it can be used correctly
		_Colour ("Tint", Color)=(0,0,0,0)
		// RGBA Red Green Blue Alpha
		_FogColour ("Fog Colour", Color) = (0,0,0,0)
		// RGBA Red Blue Green Alpha for Fog Colour

	}
	// You can have multiple sub shaders
	// These run at different GPU levels on different platforms
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
			// Tags are basically key-value pairs
			// Inside a sub shader tags are used to determine rendering order and other paramaters of a SubShader
			// RenderType tag categorizes shaders into several predefined groups
		}
		CGPROGRAM // This is the start of our C for Graphics Language 
		#pragma surface MainColour Lambert finalcolor:FogColour vertex:Vert
		// The surface of our model is affected by the mainColour function
		// The material type is Lambert
		// Lambert is a flat material that has no specular(shiny spots)
		// Lambert is a flat colour like a mat colour, no light, reflection and no shinynes
		sampler2D _Texture;
		// This connects our _Texture varible that is in the Properties section to our 2D _Texture varible in CGPROGRAM
		sampler2D _NormalMap; // Connects our _NormalMap variable from Properties to the _NormalMap Variable in CG
		fixed4 _Colour;
		// Reference to the input _Colour in the Properties section
		// Fixed4 is 4 small decimals
		// Allows us to store RGBA

		/*
		High precision: float = 32 bits
		Medium precision: float = 16 bits	Range -60000 to +60000
		Low precision: float = 11 bits	Range -2.0 to + 2.0
		*/

		fixed4 _FogColour;
		// Reference to the input _FogColour in the Properties section

		struct Input
		{
			float2 uv_Texture;
			// This is in reference to our UV map of our model
			// UV maps are wrapping of a model
			// The letters "U" and "V" deonte the axis of the 2D texture because X, Y and Z are already used to denote the axis of the 3D object in model space
			float2 uv_NormalMap;
			// UV map link to the _NormalMap image
			half fog;

		};

		void Vert(inout appdata_full v, out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input, data);
			float4 hpos = UnityObjectToClipPos(v.vertex);
			hpos.xy /= hpos.w;
			data.fog = min(1, dot(hpos.xy, hpos.xy)*0.5);
		}

		void FogColour(Input IN, SurfaceOutput o, inout fixed4 colour)
		{
			fixed3 fogColour = _FogColour.rgb;
			#ifdef UNITY_PASS_FORWARDADD
			fogColour = 0;
			#endif
			colour.rgb = lerp(colour.rgb, fogColour, IN.fog);
		}

		void MainColour(Input IN, inout SurfaceOutput o)
		{
		o.Albedo = tex2D(_Texture, IN.uv_Texture).rgba * _Colour;
		// Albedo is in reference to the surface image and rgb of our model
		// RGB = Red, Green, Blue
		// We are setting the models surface to the colour of our texture2D
		// And matching the Texture to our models UV mapping
		o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
		// _NormalMap is in reference to the bump map in Properties
		// UnpackNormal is required because the file is compressed
		// We need to decompress and get the true value from the image
		// Bump maps are visible when light reflects off
		// The light is bounced off the angles according to the image RGB or XYZ values
		// This creates the illusion of depth
		}
		ENDCG // This is the end of our C for Graphics Language 
	}
	FallBack "Diffuse" // If all else fails standard shader(Lambert abd Texture)
}