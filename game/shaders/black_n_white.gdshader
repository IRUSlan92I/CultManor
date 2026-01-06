shader_type canvas_item;

uniform vec4 black_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 white_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool switch_colors = false;
uniform float threshold : hint_range(0.0, 1.0) = 0.5;
uniform float speed : hint_range(0.0, 10.0) = 5.0;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;
uniform float scale : hint_range(0.0, 100.0) = 20.0;

float rand(vec2 coord) {
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

float cellular(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	float min_dist = 1.0;

	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x), float(y));
			vec2 point = vec2(rand(i + neighbor), rand(i + neighbor + vec2(1000.0)));
			point = 0.5 * sin(TIME * speed + 6.2831 * point);
			vec2 diff = neighbor + point - f;
			float dist = length(diff);
			min_dist = min(min_dist, dist);
		}
	}

	return min_dist;
}

void fragment() {
	if (COLOR.a != 0.0) {
		float l = dot(COLOR.rgb, vec3(0.2126, 0.7152, 0.0722));

		bool is_black = l < threshold;
		if (switch_colors) {
			is_black = !is_black;
		}
		if (intensity < 1.0) {
			vec2 coord = UV * scale;
			if (cellular(coord) > intensity) {
				is_black = !is_black;
			}
		}

		if (is_black) {
			COLOR = black_color;
		}
		else {
			COLOR = white_color;
		}
	}
}
