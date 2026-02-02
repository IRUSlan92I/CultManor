extends PlayerState


func enter() -> void:
	player.sprite.speed_scale = 1
	player.sprite.play(PlayerSprite.ANIMATION_WALK_LEFT)


func process(delta: float) -> void:
	player.sprite.speed_scale = -player.velocity.x / player.max_speed
	super.process(delta)
