extends PlayerState


func enter() -> void:
	player.sprite.speed_scale = 1
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_death, player.global_position)
	player.sprite.animation_finished.connect(_on_aniimation_finished)
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.sprite.play(PlayerSprite.ANIMATION_DEATH)
	get_tree().paused = true


func exit() -> void:
	player.sprite.animation_finished.disconnect(_on_aniimation_finished)


func physics_process(_delta: float) -> void:
	pass


func _on_aniimation_finished() -> void:
	player.process_dead()
