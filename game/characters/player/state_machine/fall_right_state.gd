extends PlayerState


const ANIMATION_FALL_RIGHT = "fall_right"


func enter() -> void:
	player.sprite.play(ANIMATION_FALL_RIGHT)
