extends CultistState


@export var fall_state: CultistState
@export var chase_left_state: CultistState
@export var chase_right_state: CultistState


func enter() -> void:
	cultist.sprite.play(CultistSprite.LOOK_AROUND_ANIMATIONS.pick_random())
	cultist.velocity = Vector2.ZERO
	_set_ray_cast_enable(cultist.left_player_close_ray, true)
	_set_ray_cast_enable(cultist.right_player_close_ray, true)


func physics_process(_delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
		return
	
	if _chase_if_player_in_ray_cast(cultist.left_player_close_ray, chase_left_state):
		return
	
	if _chase_if_player_in_ray_cast(cultist.right_player_close_ray, chase_right_state):
		return


func exit() -> void:
	_set_ray_cast_enable(cultist.left_player_close_ray, false)
	_set_ray_cast_enable(cultist.right_player_close_ray, false)
