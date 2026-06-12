extends CultistJumpState


func enter() -> void:
	super.enter()
	_direction = DIRECTION_LEFT
	cultist.animated_sprite.play(CultistSprite.ANIMATION_JUMP_LEFT)
