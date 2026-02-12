extends CultistJumpState


func enter() -> void:
	super.enter()
	_direction = DIRECTION_RIGHT
	cultist.sprite.play(CultistSprite.ANIMATION_JUMP_RIGHT)
