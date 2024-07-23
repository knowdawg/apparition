shader_type canvas_item;

uniform float FOV : hint_range(0.0, 30.0);
uniform vec3 cameraPos;
uniform float hRes;
uniform float vRes;
uniform vec3 color : source_color;
uniform float xDisplacemnt : hint_range(-1.0, 1.0, 0.1);

float sdSphere( vec3 p, float s ){
  return length(p)-s;
}

float sdBox( vec3 p, vec3 b ){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sdVerticalCapsule( vec3 p, float h, float r )
{
  p.y -= clamp( p.y, 0.0, h );
  return length( p ) - r;
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
	float fractal = sdBox(pos, vec3(0.75));
	for(int i = 0; i < 8; i++){
		pos.xz *= rot2D(PI / 12.0);
		vec3 tempPos = pos;
		float modVal = pow(0.5, float(i));
		tempPos = mod(pos, modVal) - (modVal / 2.0);
		fractal = max(-sdBox(tempPos, vec3(modVal / 3.0, modVal / 3.0, modVal / 3.0)), fractal);
	}
	
	return fractal;
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
	vec3 c = vec3(1.0, 1.0, 1.0);
	
	//Camera Rotation
	//float angle = PI / 7.0;
	//rayOrigin.xz *= rot2D(TIME * 0.2);
	//rayDirection.xz *= rot2D(TIME * 0.2);
	
	
	//Raymarching
	float ambOcc = 0.0;
	for(int i = 0; i < 80; i++){
		vec3 p = rayOrigin + rayDirection * totalDis;
		float SDFdis = map(p);
		totalDis += SDFdis;
		
		ambOcc = float(i) / 80.0;
		if(SDFdis < 0.001 || SDFdis > 100.0) break;
	}
	
	vec3 pos = rayOrigin + rayDirection * totalDis;
	
	float fog = distance(cameraPos, pos);
	c = vec3(ambOcc) * color;
	c += vec3(fog) * color * 0.7;
	
	c = clamp(c, vec3(0.0), vec3(1.0));
	
	COLOR = vec4(c, 1.0);
}