class_name CultistFallSidewaysState
extends CultistFallState


@export var fall_state: CultistState


func physics_process(delta: float) -> void:
	var is_on_floor := _move_down_and_check_floor(delta)
	if not is_on_floor and is_zero_approx(cultist.velocity.x):
		switch_state.emit(fall_state)
