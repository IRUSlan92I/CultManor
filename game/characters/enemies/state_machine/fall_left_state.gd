extends CultistFallSidewaysState


func enter() -> void:
	cultist.animated_sprite.play(CultistSprite.ANIMATION_FALL_LEFT)
