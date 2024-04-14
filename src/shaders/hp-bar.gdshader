shader_type canvas_item;

uniform sampler2D tex;
uniform sampler3D noise;
uniform float value;

const float XOFF = 1.0 / 15.0;
const float REPEAT = 2.0;

void fragment() {
	if (COLOR.r < 0.1) {
		if (UV.x > value) discard;
		vec2 uv = UV;
		float one = 1.0;
		uv.x = modf(uv.x * REPEAT, one);
		uv.x = XOFF * (uv.x + float(int(TIME * 8.0) % 15));
		uv = vec2(ivec2(uv * vec2(240, 16))) / vec2(240, 16);
		vec3 uvt = vec3(uv, sin(TIME));
		uvt.x *= 10.0;
		vec2 m = vec2(texture(noise, uvt).r, texture(noise, vec3(uvt.y, uvt.x, uvt.z)).r);
		uv += m * 0.015;
		COLOR = texture(tex, uv);
	}
}
