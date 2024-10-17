shader_type canvas_item;

uniform float FOV : hint_range(0.0, 30.0);
uniform vec3 cameraPos;
uniform float hRes;
uniform float vRes;
uniform vec3 color : source_color;
uniform float xDisplacemnt : hint_range(-1.0, 1.0, 0.1);

float sdBox( vec3 p, vec3 b ){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float smin(float a, float b, float k){
	float h = max(k - abs(a-b), 0.0) / k;
	return min(a, b) - h * h * h * k * (1.0/6.0);
}

mat2 rot2D(float angle){
	float s = sin(angle);
	float c = cos(angle);
	return mat2(vec2(c, -s), vec2(s, c));
}

float map(vec3 pos){
	vec3 tempPos = pos;
	tempPos = fract(pos) - 0.5;
	tempPos.xz *= rot2D(pos.y * 2.0 + TIME);
	
	float pillar = sdBox(tempPos, vec3(0.1, 0.5, 0.1));
	
	float walls = -abs(pos.y) + 1.5;
	
	return smin(walls, pillar, 0.5);
}

void fragment() {
	//Quantize
	vec2 qUV = vec2(floor((UV.x +  xDisplacemnt) * hRes) / hRes, floor(UV.y * vRes) / vRes);
	
	//Clip Space
	vec2 clipUV = qUV * 2.0 - 1.0;
	vec2 iResolution = 1.0 / TEXTURE_PIXEL_SIZE;
	clipUV.x *= iResolution.x / iResolution.y;
	
	//Initialization
	vec3 rayOrigin = cameraPos;
	vec3 rayDirection = normalize(vec3(clipUV, 1.0 / FOV));
	float totalDis = 0.0;
	vec3 c = vec3(1.0);
	
	//Raymarching
	for(int i = 0; i < 30; i++){
		vec3 p = rayOrigin + rayDirection * totalDis;
		float SDFdis = map(p);
		totalDis += SDFdis;
		
		c = vec3(float(i) / 60.0);
		if(SDFdis < 0.001 || SDFdis > 100.0) break;
	}
	
	c = clamp(c, vec3(0.0), vec3(1.0));
	c *= color;
	
	COLOR = vec4(c, 1.0);
}