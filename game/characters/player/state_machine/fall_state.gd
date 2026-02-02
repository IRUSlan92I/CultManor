extends PlayerState


const ANIMATION_FALL = "fall"


func enter() -> void:
	player.sprite.play(ANIMATION_FALL)
