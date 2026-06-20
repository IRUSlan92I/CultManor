@tool
class_name AbstractColorPlatform
extends AbstractPlatform


enum PlatformColor {
	White,
	Black,
}


@export var initial_color := PlatformColor.White


@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher


func _ready() -> void:
	super._ready()
	collision_switcher.add_material(platform_sprite.material)
	if initial_color == PlatformColor.Black:
		collision_switcher.switch_color()
