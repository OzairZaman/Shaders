// This section allows for easy sorting for our shader in the shader menu
Shader "Lesson/Albedo"
{
	// Properties are the public Properties on a material
	Properties
	{
		_Texture("Texture",2D) = "black"{}
		// Our varible name is _Texture
		// Our display name is Texture
		// It is of type 2D and the default untextured colour is black
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
		#pragma surface MainColour Lambert
		// The surface of our model is affected by the mainColour function
		// The material type is Lambert
		// Lambert is a flat material that has no specular(shiny spots)
		// Lambert is a flat colour like a mat colour, no light, reflection and no shinynes
		sampler2D _Texture;
		// This connects our _Texture varible that is in the Properties section to our 2D _Texture varible in CGPROGRAM
		struct Input
		{
			float2 uv_Texture;
			// This is in reference to our UV map of our model
			// UV maps are wrapping of a model
			// The letters "U" and "V" deonte the axis of the 2D texture because X, Y and Z are already used to denote the axis of the 3D object in model space

		};
		void MainColour(Input IN, inout SurfaceOutput o)
		{
		o.Albedo = tex2D(_Texture, IN.uv_Texture).rgb;
		// Albedo is in reference to the surface image and rgb of our model
		// RGB = Red, Green, Blue
		// We are setting the models surface to the colour of our texture2D
		// And matching the Texture to our models UV mapping
		}
		ENDCG // This is the end of our C for Graphics Language 
	}
	FallBack "Diffuse" // If all else fails standard shader(Lambert abd Texture)
}