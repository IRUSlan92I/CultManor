extends CultistFallState


@export var fall_state: CultistState


func enter() -> void:
	cultist.sprite.play(CultistSprite.ANIMATION_FALL_RIGHT)


func physics_process(delta: float) -> void:
	cultist.velocity += cultist.get_gravity() * delta
	cultist.move_and_slide()
	if cultist.is_on_floor():
		switch_state.emit(look_around_state)
	elif is_zero_approx(cultist.velocity.x):
		switch_state.emit(fall_state)
