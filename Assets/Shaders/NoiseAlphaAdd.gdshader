shader_type canvas_item;

uniform sampler2D noise;

uniform vec2 center;
uniform float progress : hint_range(0.0, 1.0, 0.05);
uniform float intensity : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	
	c.a = step(1.0 - progress, c.r);
	c.rgb = vec3(1.0, 1.0, 1.0);
	c *= texture(noise, UV);
	
	float dis = distance(center, UV);
	dis = smoothstep(1.0 - progress, 1.0, dis);
	
	c += dis * progress;
	c += progress * 0.3;
	c.a -= 1.0 - intensity;
	
	COLOR = c;
}
