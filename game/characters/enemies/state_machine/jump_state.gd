@abstract
class_name CultistJumpState
extends CultistState


@export var chase_state: CultistState


var _direction := 0


func enter() -> void:
	cultist.velocity.y -= cultist.JUMP_VELOCITY


func physics_process(delta: float) -> void:
	if cultist.is_on_floor():
		switch_state.emit(chase_state)
	else:
		cultist.velocity += cultist.get_gravity() * cultist.get_gravity_factor() * delta
		cultist.update_x_velocity(_direction, cultist.MAX_WALK_SPEED, delta)
