class_name CultistState
extends AbstractState


@export var cultist: AbstractCultist


func _get_colliding_player(ray_cast: RayCast2D) -> Player:
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		var collider := ray_cast.get_collider()
		if collider is Player:
			return collider
	return null
