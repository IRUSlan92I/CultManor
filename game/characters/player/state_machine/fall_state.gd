extends PlayerState


func enter() -> void:
	player.sprite.play(PlayerSprite.ANIMATION_FALL)
