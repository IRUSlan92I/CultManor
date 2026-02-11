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


func _chase_if_player_in_ray_cast(ray_cast: RayCast2D, chase_state: CultistState) -> bool:
	var player := _get_colliding_player(ray_cast)
	if player != null:
		cultist.target_x = player.position.x
		switch_state.emit(chase_state)
		return true
	return false
