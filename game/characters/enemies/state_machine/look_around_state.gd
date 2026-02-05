extends CultistState


func enter() -> void:
	cultist.sprite.play(CultistSprite.LOOK_AROUND_ANIMATIONS.pick_random())
	_set_ray_cast_enable(cultist.left_player_close_ray, true)
	_set_ray_cast_enable(cultist.right_player_close_ray, true)


func exit() -> void:
	_set_ray_cast_enable(cultist.left_player_close_ray, false)
	_set_ray_cast_enable(cultist.right_player_close_ray, false)
