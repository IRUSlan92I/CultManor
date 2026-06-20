@tool
class_name TriggerColorPlatform
extends AbstractColorPlatform


const SWITCH_TIME = 0.2


func _ready() -> void:
	super._ready()
	icon_sprite.play(ANIMATION_COLOR_SWITCHING)


func toggle() -> void:
	collision_switcher.switch_color(SWITCH_TIME)
