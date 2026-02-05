class_name CultistFallState
extends CultistState


@export var look_around_state: CultistState


func enter() -> void:
	cultist.sprite.play(CultistSprite.ANIMATION_FALL)


func physics_process(delta: float) -> void:
	cultist.velocity += cultist.get_gravity() * delta
	cultist.move_and_slide()
	if cultist.is_on_floor():
		switch_state.emit(look_around_state)
