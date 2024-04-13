shader_type canvas_item;

uniform float line_length;
uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float t = (sin(TIME * 4.0) + 1.0) * 0.5;
	vec2 p = vec2(UV.x * line_length * 0.02, min(abs(UV.y - 0.5) * 1.5, 0.7));
	vec2 t_uv = vec2(p.x, t * 1.8) * 0.01;
	float q = texture(noise, t_uv + vec2(texture(noise, t_uv).r, texture(noise, t_uv + vec2(5.0, 5.0)).r)).r + 0.1;
	float dp = min(max(q - p.y, 0.0) * 1.5, 1.0);
	COLOR = vec4(vec3(0.2, 0.0, 0.0) * (1.0 - texture(noise, t_uv).r * 0.6), dp);
	COLOR.a = pow(COLOR.a, 0.2);
	//COLOR = texture(noise, UV);
}