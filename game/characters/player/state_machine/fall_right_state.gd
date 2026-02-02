extends PlayerState


func enter() -> void:
	player.sprite.speed_scale = 1
	player.sprite.play(PlayerSprite.ANIMATION_FALL_RIGHT)
