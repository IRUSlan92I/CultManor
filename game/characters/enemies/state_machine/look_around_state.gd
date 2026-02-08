extends CultistState


@export var fall_state: CultistState


func enter() -> void:
	cultist.sprite.play(CultistSprite.LOOK_AROUND_ANIMATIONS.pick_random())
	cultist.velocity = Vector2.ZERO
	_set_ray_cast_enable(cultist.left_player_close_ray, true)
	_set_ray_cast_enable(cultist.right_player_close_ray, true)


func physics_process(_delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)


func exit() -> void:
	_set_ray_cast_enable(cultist.left_player_close_ray, false)
	_set_ray_cast_enable(cultist.right_player_close_ray, false)
