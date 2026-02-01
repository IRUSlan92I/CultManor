extends PlayerState


const ANIMATION_DEATH = "death"


func enter() -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_death, player.global_position)
	player.sprite.animation_finished.connect(_on_aniimation_finished, CONNECT_ONE_SHOT)
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.sprite.play(ANIMATION_DEATH)
	get_tree().paused = true


func _on_aniimation_finished() -> void:
	player.dead.emit()
	player.queue_free()
