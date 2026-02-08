@abstract
class_name CultistMoveState
extends CultistState


const MAX_WALK_SPEED = 85

const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1


@export var fall_state: CultistState
@export var chase_state: CultistState
@export var another_direction_move_state: CultistState


var _direction := 0
var _wall_ray_cast : RayCast2D
var _player_ray_cast : RayCast2D


func enter() -> void:
	_set_ray_cast_enable(_player_ray_cast, true)


func exit() -> void:
	_set_ray_cast_enable(_player_ray_cast, false)


func physics_process(delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
	else:
		var player := _get_colliding_player(_player_ray_cast)
		if player != null:
			cultist.target_x = player.position.x
			switch_state.emit(chase_state)
		elif _wall_ray_cast.is_colliding():
			switch_state.emit(another_direction_move_state)
		else:
			cultist.update_x_velocity(_direction, MAX_WALK_SPEED, delta)


func _get_colliding_player(ray_cast: RayCast2D) -> Player:
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		var collider := ray_cast.get_collider()
		if collider is Player:
			return collider
	return null
