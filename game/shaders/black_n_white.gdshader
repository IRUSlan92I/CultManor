shader_type canvas_item;

#include "get_black_n_white.gdshaderinc"

void fragment() {
	COLOR = get_black_and_white(COLOR, UV, TIME);
}
