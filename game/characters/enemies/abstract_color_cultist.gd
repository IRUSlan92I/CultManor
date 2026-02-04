class_name AbstractColorCultist
extends AbstractCultist


@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher


func _ready() -> void:
	super._ready()
	collision_switcher.material = sprite.material
