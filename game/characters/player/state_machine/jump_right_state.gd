extends PlayerState


const ANIMATION_JUMP_RIGHT = "jump_right"


func enter() -> void:
	player.sprite.play(ANIMATION_JUMP_RIGHT)
