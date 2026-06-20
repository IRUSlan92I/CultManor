@tool
class_name TouchColorPlatform
extends AbstractColorPlatform


@onready var touch_check_collision: CollisionShape2D = $Area2D/CollisionShape2D

func rebuild_platform() -> void:
	super.rebuild_platform()
	touch_check_collision.shape.size.x = platform_width - 4
