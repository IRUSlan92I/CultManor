shader_type canvas_item;

uniform float tile_size = 8.0;
uniform float platform_width = 24.0;
uniform sampler2D atlas : filter_nearest;
uniform float seed : hint_range(0.0, 1.0) = 0.0;

const float left_cap_count = 2.0;
const float gap_count = 8.0;
const float right_cap_count = 2.0;

float random(float v, float s) {
	return fract(sin(v * 127.1 + s * 100.0) * 43758.5453);
}

void fragment() {
	vec2 platform_pixel = UV * vec2(platform_width, tile_size);
	vec2 atlas_pixel = platform_pixel;

	float column = floor(platform_pixel.x / tile_size);
	float rand_val = random(column, seed);
	float tile_offset_x = mod(platform_pixel.x, tile_size);

	if (platform_pixel.x < tile_size) {
		float cap_index = floor(rand_val * left_cap_count);
		atlas_pixel.x = cap_index * tile_size + tile_offset_x;
	} else if (platform_pixel.x < platform_width - tile_size) {
		float gap_index = floor(rand_val * gap_count);
		atlas_pixel.x = left_cap_count * tile_size + gap_index * tile_size + tile_offset_x;
	} else {
		float cap_index = floor(rand_val * right_cap_count);
		atlas_pixel.x = (left_cap_count + gap_count) * tile_size + cap_index * tile_size + tile_offset_x;
	}

	vec2 atlas_size = vec2(textureSize(atlas, 0));
	vec2 atlas_uv = atlas_pixel / atlas_size;
	COLOR = texture(atlas, atlas_uv);
}
