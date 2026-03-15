@abstract
class_name CultistChaseState
extends CultistMoveState


@export var look_around_state: CultistState
@export var jump_state: CultistState


func physics_process(delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
	else:
		var player := _get_colliding_player(_player_ray_cast)
		if player != null:
			cultist.target_x = player.position.x
		
		if _is_target_reached() or _wall_high_ray_cast.is_colliding():
			var stream := SoundManager.sfx_stream_player_lost
			SoundManager.play_sfx_stream(stream, cultist.global_position)
			switch_state.emit(look_around_state)
		elif _wall_low_ray_cast.is_colliding():
			switch_state.emit(jump_state)
		else:
			cultist.update_x_velocity(_direction, cultist.MAX_CHASE_SPEED, delta)


@abstract
func _is_target_reached() -> bool
