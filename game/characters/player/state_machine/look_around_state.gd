extends PlayerState


func enter() -> void:
	player.sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	player.sprite.play(_get_animation())


func _on_animation_finished() -> void:
	switch_state.emit(idle_state)


func _get_animation() -> String:
	if randi_range(1, 2) == 1:
		return PlayerSprite.ANIMATION_LOOK_AROUND_1
	else:
		return PlayerSprite.ANIMATION_LOOK_AROUND_2
