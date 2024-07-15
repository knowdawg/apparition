shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec4 color : source_color;
uniform float brightness : hint_range(0.0, 0.3, 0.01);

void fragment() {
	vec2 clipUV = (UV - vec2(0.5, 0.5)) * 2.0;
	vec4 n = (texture(noise, UV)) - 0.5;
	clipUV.x += n.r * 0.1;
	
	float l = length(clipUV);
	l = sin(l * 6.0 - TIME) / 6.0;
	l = abs(l);
	l += smoothstep(0.5, 1.5, length(clipUV));
	l = brightness / l;
	
	
	
	COLOR = vec4(l, l, l, l) * color;
	COLOR.a = 0.0;
}
