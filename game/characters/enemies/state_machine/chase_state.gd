class_name CultistChaseState
extends CultistMoveState


@export var look_around_state: CultistState


func physics_process(delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
	else:
		var player := _get_colliding_player(_player_ray_cast)
		if player != null:
			cultist.target_x = player.position.x
		
		if is_equal_approx(cultist.position.x, cultist.target_x):
			switch_state.emit(look_around_state)
		else:
			cultist.update_x_velocity(_direction, cultist.MAX_CHASE_SPEED, delta)
