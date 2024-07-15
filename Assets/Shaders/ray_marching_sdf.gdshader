shader_type canvas_item;

uniform float FOV : hint_range(0.0, 30.0);
uniform vec3 cameraPos;
uniform float hRes;
uniform float vRes;

float sdSphere( vec3 p, float s ){
  return length(p)-s;
}

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
	
	vec3 spherePos = pos;
	vec3 squarePos = pos - vec3(0.0, 0.75, 0.0);
	squarePos.xz *= rot2D(TIME * 0.5);
	float sphere = max(-sdSphere(spherePos, 0.9), sdBox(squarePos, vec3(0.75)));
	
	vec3 squarePos2 = pos - vec3(0.0, -1.0, 0.0);
	squarePos2.xz *= rot2D(-TIME * 0.5);
	sphere = min(sphere, max(-sdSphere(spherePos + vec3(0.0, 0.3, 0.0), 0.9), sdBox(squarePos2, vec3(0.75, 0.5, 0.75))));
	
	vec3 tempPos = pos;
	tempPos = mod(pos, 1.0) - 0.5;
	tempPos.xy *= rot2D(pos.z);
	
	float box = sdBox(tempPos, vec3(0.1));
	
	float ground = -pos.y + 0.75;
	
	return smin(ground, smin(sphere, box, 0.5), 0.5);
}

void fragment() {
	//Quantize
	vec2 qUV = vec2(floor(UV.x * hRes) / hRes, floor(UV.y * vRes) / vRes);
	
	//Clip Space
	vec2 clipUV = qUV * 2.0 - 1.0;
	vec2 iResolution = 1.0 / TEXTURE_PIXEL_SIZE;
	clipUV.x *= iResolution.x / iResolution.y;
	
	//Initialization
	vec3 rayOrigin = cameraPos;
	vec3 rayDirection = normalize(vec3(clipUV, 1.0 / FOV));
	float totalDis = 0.0;
	vec3 color = vec3(0.0);
	
	//Camera Rotation
	//rayOrigin.xz *= rot2D(TIME * 0.2);
	//rayDirection.xz *= rot2D(TIME * 0.2);
	
	//Raymarching
	int i = 0;
	for(int i = 0; i < 80; i++){
		vec3 p = rayOrigin + rayDirection * totalDis;
		float SDFdis = map(p);
		totalDis += SDFdis;
		
		color = vec3(float(i) / 80.0);
		if(SDFdis < 0.001 || SDFdis > 100.0) break;
	}
	
	//color *= vec3(totalDis) * 0.2;
	//color = vec3(1.0) - color;
	color *= vec3(1.0, 0.2, 0.1);
	
	COLOR = vec4(color, 1.0);
}
