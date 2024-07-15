shader_type canvas_item;

uniform sampler2D noise;

void fragment() {
	vec4 c = texture(noise, UV);
	
	COLOR = c;
}
