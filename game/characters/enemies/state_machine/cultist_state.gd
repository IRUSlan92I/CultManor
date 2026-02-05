class_name CultistState
extends AbstractState


@export var cultist: AbstractCultist


func _set_ray_cast_enable(ray_cast: RayCast2D, enabled: bool) -> void:
	ray_cast.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
