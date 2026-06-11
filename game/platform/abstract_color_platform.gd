@tool
class_name AbstractColorPlatform
extends AbstractPlatform


@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher


func _ready() -> void:
	super._ready()
	collision_switcher.material = platform_rect.material
