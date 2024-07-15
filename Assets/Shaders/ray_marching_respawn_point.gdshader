shader_type canvas_item;

uniform float FOV : hint_range(0.0, 30.0);
uniform vec3 cameraPos;
uniform float progress : hint_range(0.0, 1.0);
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
	
	mat2 rotationMatrix = rot2D(TIME);
	
	vec3 square1 = pos;
	vec3 square2 = pos;
	vec3 square3 = pos;
	
	square1.yz *= rotationMatrix;
	square1 -= vec3(0.0, 1.0, 1.0) * progress * 0.8;
	
	square2.xy *= rotationMatrix;
	square2 -= vec3(1.0, -1.0, 0.0) * progress * 0.8;
	
	square3.xz *= rotationMatrix;
	square3 -= vec3(-1.0, 0.0, -1.0) * progress * 0.8;
	
	float box1 = sdBox(square1, vec3(0.4));
	float box2 = sdBox(square2, vec3(0.4));
	float box3 = sdBox(square3, vec3(0.4));
	float sphere = sdSphere(pos, 0.3);
	
	float boxes = min(sphere, smin(box3, smin(box1, box2, 0.5), 0.5));
	
	return boxes;
}

void fragment() {
	//Quantize
	vec2 qUV = vec2(floor(UV.x * hRes + 0.5) / hRes, floor(UV.y * vRes + 0.5) / vRes);
	
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
	rayOrigin.xy *= rot2D(TIME * 0.2);
	rayDirection.xy *= rot2D(TIME * 0.2);
	
	rayOrigin.xz *= rot2D(TIME * 0.2);
	rayDirection.xz *= rot2D(TIME * 0.2);
	
	rayOrigin.yz *= rot2D(TIME * 0.2);
	rayDirection.yz *= rot2D(TIME * 0.2);
	
	//Raymarching
	int numOfCasts = 0;
	for(int i = 0; i < 80; i++){
		vec3 p = rayOrigin + rayDirection * totalDis;
		float SDFdis = map(p);
		totalDis += SDFdis;
		
		color = vec3(float(i) / 80.0);
		//color = vec3(distance(p, vec3(0.0, 0.0, 0.0)));
		if(SDFdis < 0.001){
			break;
		}
		if(SDFdis > 100.0){
			numOfCasts = 5000;
			break;
		}
		numOfCasts++;
	}
	
	//color = vec3(totalDis) * 0.2;
	//color = vec3(1.0) - color * 0.5;
	color *= vec3(1.0, 0.2, 0.1);
	
	COLOR = vec4(color, smoothstep(0.00, 0.04, 1.0 / float(numOfCasts)));
}
