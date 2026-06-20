shader_type canvas_item;

varying vec2 world_pos;

uniform vec4 black_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 white_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool switch_colors = false;
uniform float threshold : hint_range(0.0, 1.0) = 0.5;
uniform float speed : hint_range(0.0, 10.0) = 0.5;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;
uniform float scale : hint_range(0.0, 100.0) = 20.0;
uniform float seed : hint_range(0.0, 1.0) = 0.0;
uniform vec2 direction = vec2(1.0, 1.0);
uniform bool use_world_pos = false;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract((sin(uv) + seed) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void vertex() {
	if (use_world_pos) {
    	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	}
}

void fragment() {
	if (COLOR.a > 0.01) {
		vec2 noise_uv = vec2(1.0, TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y);
		noise_uv *= use_world_pos ? world_pos : UV;
		
		float l = dot(COLOR.rgb, vec3(0.2126, 0.7152, 0.0722));

		bool is_black = l < threshold;
		if (switch_colors) {
			is_black = !is_black;
		}
		if (intensity < 1.0) {
			vec2 coord = noise_uv * scale + TIME * speed * normalize(direction);

			if (noise(coord) > intensity) {
				is_black = !is_black;
			}
		}

		COLOR = is_black ? black_color : white_color;
	}
}
