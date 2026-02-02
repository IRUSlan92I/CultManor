extends PlayerState


const ANIMATION_FALL_LEFT = "fall_left"


func enter() -> void:
	player.sprite.play(ANIMATION_FALL_LEFT)
