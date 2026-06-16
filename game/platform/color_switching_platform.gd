@tool
class_name ColorSwitchingPlatform
extends AbstractColorPlatform


func toggle() -> void:
	collision_switcher.switch_color()
