extends PlayerState


const ANIMATION_JUMP_LEFT = "jump_left"


func enter() -> void:
	player.sprite.play(ANIMATION_JUMP_LEFT)
