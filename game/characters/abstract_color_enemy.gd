class_name AbstractColorEnemy
extends AbstractEnemy


@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher


func _ready() -> void:
	collision_switcher.material = sprite.material
