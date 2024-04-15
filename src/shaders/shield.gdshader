shader_type canvas_item;

const float thickness = 0.02;
const float feather = 0.005;

uniform sampler2D noise;

vec2 rotate(vec2 v, float angle) {
	float s = sin(angle);
	float c = cos(angle);
	return mat2(vec2(c, s), vec2(-s, c)) * v;
}

void fragment() {
	float alpha = COLOR.a * (1.0 - smoothstep(0.5 - feather, 0.5, length(UV - vec2(0.5, 0.5))));
	alpha *= smoothstep(0.5 - thickness - feather, 0.5 - thickness, length(UV - vec2(0.5, 0.5)));
	alpha *= texture(noise, rotate(UV, TIME)).r;
	COLOR = vec4(0.0, 0.0, 1.0, alpha);
}
