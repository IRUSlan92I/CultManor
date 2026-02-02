extends PlayerState


const ANIMATION_JUMP = "jump"


func enter() -> void:
	player.sprite.play(ANIMATION_JUMP)
