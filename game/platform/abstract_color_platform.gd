@tool
class_name AbstractColorPlatform
extends AbstractPlatform


@export var initial_color := CollisionSwitcher.ObjectColor.White:
	set(value):
		initial_color = value
		if Engine.is_editor_hint() and is_node_ready():
			collision_switcher.switch_color()


@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher


func _ready() -> void:
	super._ready()
	collision_switcher.add_material(platform_sprite.material)
	if initial_color == CollisionSwitcher.ObjectColor.Black:
		collision_switcher.switch_color()
