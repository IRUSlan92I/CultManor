shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    vec3 inverted_color = 1.0 - screen_color.rgb;
    COLOR.rgb = vec3(inverted_color);
}