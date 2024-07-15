shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D curve;
uniform float strength;

void fragment() {
	vec2 vecToCenter = vec2(0.5, 0.5) - UV;
	float dis = length(vecToCenter);
	float cVal = texture(curve, vec2(dis)).r;
	vec2 diff = normalize(vecToCenter) * strength * cVal;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - diff);
}