shader_type canvas_item;
//random shader that makes pixels slightly darker, edited from a visualShader, lol. I don't know how to do these things myself
//also puts a fat hole in the foreground so you can see your mans
const vec3 brightness = vec3(1.2, 1.1, 1.15);
const float saturation = 0.6;
const vec2 myCenter = vec2(0.5, 0.45);
const float inverseHoleSize = 30.0;
const float holeOffset = 3.0;

const float benDay = 240.0;//comic book effect fade for the edges of the circle thing

float getDistance(float x, float y, float aspectRatio){
	x = abs(x-myCenter.x);
	y = abs(y-myCenter.y)*aspectRatio;
	return sqrt((x*x) + (y*y));
}

float minVal(float a, float b)
{
	//haha! got away with it without branching! shader magic is wild. 
	//https://stackoverflow.com/questions/45597118/fastest-way-to-do-min-max-based-on-specific-component-of-vectors-in-glsl
    return mix(a, b, step(b, a));
}
float maxVal(float a, float b)
{
	return mix(a, b, step(a, b));
}

void fragment() {
	float aspectRatio = SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	vec4 myTexture = texture(TEXTURE , UV.xy);
	//https://godotshaders.com/shader/desaturation-shader/ stole this shit
	vec3 desaturated = mix(vec3(dot(myTexture.rgb, vec3(0.299, 0.587, 0.114))), myTexture.rgb, saturation);
	
	float holeAlpha = clamp(getDistance(SCREEN_UV.x, SCREEN_UV.y, aspectRatio)*inverseHoleSize-holeOffset, 0.0, 1.0);
	holeAlpha = maxVal(holeAlpha * mod(SCREEN_UV.x*benDay + SCREEN_UV.y*benDay, 0.5)*4.0, holeAlpha);
	COLOR.rgb = brightness * desaturated;
	COLOR.a = minVal(holeAlpha, myTexture.a);
}

