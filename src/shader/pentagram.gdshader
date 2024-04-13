shader_type canvas_item;

uniform float line_length;
uniform sampler2D noise;
const float freq = 0.004;
const float time_mult = 1.5;
const float edge_gradient_mult = 2.0;
const float min_width = 0.25;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float d_mid = abs(UV.y - 0.5) * 2.0;

	float line_coord = UV.x * line_length;
	float sample_dist = line_coord * freq + (TIME * time_mult);
	sample_dist = mod(sample_dist, 1.0);
	float width = texture(noise, vec2(sample_dist)).r;
	width = (1.0 - min_width) * width + min_width;

	if (width > d_mid) {
		//float alpha = 1.0;
		float alpha = (1.0 - d_mid / width) * edge_gradient_mult;
		alpha = pow(alpha, 5.0);
		COLOR = vec4(0.2 * (1.0 - d_mid), 0.0, 0.0, alpha);
	} else {
		discard;
	}
}