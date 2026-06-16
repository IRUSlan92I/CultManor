shader_type canvas_item;

uniform float glow_interval : hint_range(0.0, 1.0, 0.00001) = 1.0;
uniform float glow_radius : hint_range(0.0, 1.0, 0.00001) = 1.0;
uniform float travel_time : hint_range(0.0, 100.0, 1) = 5.0;

float get_alpha(vec2 uv, float offset) {
	float dist = fract(mod(TIME, travel_time)/travel_time + offset);
	float left = uv.x - glow_radius;
	float right = uv.x + glow_radius;
	return step(left, dist) * (1.0 - step(right, dist));
}

void fragment() {
	float alpha = 0.0;
	float offset = 0.0;
	
	for (float offset = 0.0; offset <= 1.0; offset += glow_interval) {
		alpha += get_alpha(UV, offset);
	}
	
	COLOR.a = alpha;
}
