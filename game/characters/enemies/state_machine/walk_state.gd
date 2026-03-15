@abstract
class_name CultistWalkState
extends CultistMoveState


@export var chase_state: CultistState
@export var another_direction_walk_state: CultistState


func physics_process(delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
	else:
		var player := _get_colliding_player(_player_ray_cast)
		if player != null:
			switch_state.emit(chase_state)
		else:
			if _wall_low_ray_cast.is_colliding() or _wall_high_ray_cast.is_colliding():
				switch_state.emit(another_direction_walk_state)
			else:
				cultist.update_x_velocity(_direction, cultist.MAX_WALK_SPEED, delta)
