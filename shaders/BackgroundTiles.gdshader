shader_type canvas_item;
//random shader that makes pixels slightly darker, edited from a visualShader, lol. I don't know how to do these things myself
const vec3 brightness = vec3(0.5, 0.5, 0.6);
const float saturation = 1.5;


void fragment() {
	vec4 myTexture = texture(TEXTURE , UV.xy);
	vec3 desaturated = mix(vec3(dot(myTexture.rgb, vec3(0.299, 0.587, 0.114))), myTexture.rgb, saturation);//https://godotshaders.com/shader/desaturation-shader/ stole this shit
	COLOR.rgb = brightness * desaturated; 
	COLOR.a = myTexture.a;//carry over alpha channel
}