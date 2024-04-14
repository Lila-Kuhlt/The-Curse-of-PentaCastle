shader_type canvas_item;

uniform float value;

void fragment() {
	COLOR = mix(COLOR, vec4(0.8, 0.0, 0.0, COLOR.a), value);
}