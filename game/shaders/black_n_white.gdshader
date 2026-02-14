shader_type canvas_item;

uniform vec4 black_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 white_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool switch_colors = false;
uniform float threshold : hint_range(0.0, 1.0) = 0.5;
uniform float speed : hint_range(0.0, 10.0) = 0.5;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;
uniform float scale : hint_range(0.0, 100.0) = 20.0;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
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


void fragment() {
	if (COLOR.a > 0.01) {
		float l = dot(COLOR.rgb, vec3(0.2126, 0.7152, 0.0722));

		bool is_black = l < threshold;
		if (switch_colors) {
			is_black = !is_black;
		}
		if (intensity < 1.0) {
			vec2 coord = UV * scale + TIME * speed;
			if (noise(coord) > intensity) {
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
