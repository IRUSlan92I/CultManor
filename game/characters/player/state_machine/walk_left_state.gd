extends PlayerState


const ANIMATION_WALK_LEFT = "walk_left"


func enter() -> void:
	player.sprite.play(ANIMATION_WALK_LEFT)
