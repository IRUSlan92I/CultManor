@abstract
class_name CultistWalkState
extends CultistMoveState


@export var chase_state: CultistState
@export var another_direction_walk_state: CultistState


func physics_process(delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
	else:
		if not _chase_if_player_in_ray_cast(_player_ray_cast, chase_state):
			if _wall_ray_cast.is_colliding():
				var stream := SoundManager.sfx_stream_player_lost
				SoundManager.play_sfx_stream(stream, cultist.global_position)
				switch_state.emit(another_direction_walk_state)
			else:
				cultist.update_x_velocity(_direction, cultist.MAX_WALK_SPEED, delta)
