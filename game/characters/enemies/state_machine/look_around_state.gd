extends CultistState


@export var fall_state: CultistState
@export var walk_left_state: CultistState
@export var walk_right_state: CultistState
@export var chase_left_state: CultistState
@export var chase_right_state: CultistState


var state_by_ray_cast : Dictionary[RayCast2D, CultistState]


func enter() -> void:
	cultist.sprite.animation_finished.connect(_on_animation_finished)
	cultist.sprite.play(CultistSprite.LOOK_AROUND_ANIMATIONS.pick_random())
	cultist.velocity = Vector2.ZERO
	cultist._set_ray_cast_enable(cultist.left_player_close_ray, true)
	cultist._set_ray_cast_enable(cultist.right_player_close_ray, true)
	
	state_by_ray_cast = {
		cultist.left_player_close_ray: chase_left_state,
		cultist.right_player_close_ray: chase_right_state,
	}


func physics_process(_delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
	else:
		for ray_cast in state_by_ray_cast:
			var player := _get_colliding_player(ray_cast)
			if player != null:
				switch_state.emit(state_by_ray_cast[ray_cast])
				break


func exit() -> void:
	cultist.sprite.animation_finished.disconnect(_on_animation_finished)
	cultist._set_ray_cast_enable(cultist.left_player_close_ray, false)
	cultist._set_ray_cast_enable(cultist.right_player_close_ray, false)


func _on_animation_finished() -> void:
	switch_state.emit([walk_left_state, walk_right_state].pick_random())
