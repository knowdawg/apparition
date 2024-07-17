shader_type canvas_item;

uniform float FOV : hint_range(0.0, 30.0);
uniform vec3 cameraPos;
uniform float hRes;
uniform float vRes;
uniform float progress : hint_range(0.0, 1.5);
uniform vec3 lightPos;

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
	tempPos.xy *= rot2D(pos.z);
	
	float box = sdBox(tempPos, vec3(0.1));
	
	float ground = -pos.y + 0.7;
	
	return smin(box, ground, 0.5);
}

vec3 calcNormal( in vec3 p ) // for function f(p)
{
    const float eps = 0.0001; // or some other value
    const vec2 h = vec2(eps,0);
	
	float mapP = map(p);
    return normalize( vec3(map(p+h.xyy) - mapP,
                           map(p+h.yxy) - mapP,
                           map(p+h.yyx) - mapP) );
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
	rayOrigin.xz *= rot2D(TIME * 0.1);
	rayDirection.xz *= rot2D(TIME * 0.1);
	
	//Raymarching
	int i = 0;
	for(int i = 0; i < 40; i++){
		vec3 p = rayOrigin + rayDirection * totalDis;
		float SDFdis = map(p);
		totalDis += SDFdis;
		
		//color = vec3(float(i) / 80.0);
		if(SDFdis < 0.001 || SDFdis > 100.0) break;
	}
	vec3 position = rayOrigin + rayDirection * totalDis;
	
	vec3 normal = calcNormal(rayOrigin + rayDirection * totalDis);
	
	float lightFromSource = 1.0 / distance(lightPos, position);
	float lightIntensity = smoothstep(1.0 - progress, 1.0 - progress + 0.5, lightFromSource) * smoothstep(0.0, 0.2, progress);
	lightIntensity -= smoothstep(1.0 - progress + 0.3, 1.0 - progress + 0.5, lightFromSource) * smoothstep(0.0, 1.0, progress);
	
	float lightVal = lightIntensity;
	
	//Labert Difuse
	float l = clamp(dot(normal, lightPos - position), 0.0, 1.0);
	lightIntensity *= l;
	
	lightIntensity *= lightFromSource * 2.0;
	lightIntensity = clamp(lightIntensity, 0.0, 1.0);
	
	color = vec3(1.0);
	color *= lightIntensity;
	
	color *= vec3(1.0, 0.2, 0.1);
	COLOR = vec4(color, 1.0);
}
