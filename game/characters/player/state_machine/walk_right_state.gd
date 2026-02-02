extends PlayerState


const ANIMATION_WALK_RIGHT = "walk_right"


func enter() -> void:
	player.sprite.play(ANIMATION_WALK_RIGHT)
