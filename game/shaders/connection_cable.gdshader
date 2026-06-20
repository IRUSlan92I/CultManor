shader_type canvas_item;

uniform float glow_interval : hint_range(0.0, 1.0, 0.00001) = 1.0;
uniform float glow_radius : hint_range(0.0, 1.0, 0.00001) = 1.0;
uniform float travel_time : hint_range(0.0, 100.0, 1) = 5.0;

float get_alpha(vec2 uv, float offset) {
	float progress = fract(mod(TIME, travel_time)/travel_time + offset);
	return step(distance(progress, uv.x), glow_radius);
}

void fragment() {
	COLOR.a = 0.0;
	for (float offset = 0.0; offset <= 1.0; offset += glow_interval) {
		COLOR.a += get_alpha(UV, offset);
	}
}
