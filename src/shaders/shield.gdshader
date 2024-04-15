shader_type canvas_item;

const float THICKNESS = 0.15;
const float WOBBLE = 0.6;
const vec3 BASE_COLOR = vec3(0.3, 0.2, 0.8);
const float feather = 0.005;
const float radius = 0.9;

uniform sampler2D noise;

vec2 rotate(vec2 v, float angle) {
	float s = sin(angle);
	float c = cos(angle);
	return mat2(vec2(c, s), vec2(-s, c)) * v;
}

float gtime(float scale) {
	//return (sin(mod(TIME, 2.0 * PI)) + 1.0) * 0.5;
	//return mod(TIME * scale, 128.0);
	return mod(TIME * scale, 1.0);
}

void fragment() {
	vec2 p = (UV - vec2(0.5)) * 2.0;
	vec2 np = normalize(p);
	float angle = acos(-np.x * sign(np.y)) / PI * 0.5 + step(0.0, np.y) * 0.5;
	float r = texture(noise, vec2(angle, gtime(0.2))).r;
	float thickness = THICKNESS * (1.0 - r * WOBBLE);
	float dist = length(p);
	float outer = COLOR.a * (1.0 - smoothstep(1.0 - thickness - feather, 1.0 - thickness, dist));
	float inner = smoothstep(1.0 - thickness * 2.0 - feather,  1.0 - thickness * 2.0, dist);
	vec2 uv = p;
	uv = rotate(uv, mod(TIME * 0.15, 2.0 * PI));
	uv.x += gtime(0.2);
	uv = mod(uv, 1.0);
	float neffect = texture(noise, uv).r;
	float ic = outer * neffect;
	float oc = ic * 0.2 + texture(noise, vec2(dist - texture(noise, vec2(UV)).r * 0.2, 0.0)).r * 0.5;
	float q = oc * (1.0 - inner) * outer * outer + pow(ic, 0.3) * inner;
	float alpha = pow(q, 0.45);
	COLOR = vec4(BASE_COLOR * alpha, alpha);
}
