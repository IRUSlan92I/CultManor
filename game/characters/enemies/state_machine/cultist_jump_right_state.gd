extends CultistJumpState


func enter() -> void:
	super.enter()
	_direction = DIRECTION_RIGHT
	cultist.animated_sprite.play(CultistSprite.ANIMATION_JUMP_RIGHT)
