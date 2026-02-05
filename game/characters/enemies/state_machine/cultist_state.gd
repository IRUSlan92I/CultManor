class_name CultistState
extends AbstractState


@export var cultist: AbstractCultist


func _physics_process(_delta: float) -> void:
	if !cultist.is_on_floor():
		pass


func _set_ray_cast_enable(ray_cast: RayCast2D, enabled: bool) -> void:
	ray_cast.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
