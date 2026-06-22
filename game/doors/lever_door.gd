@tool
extends Door


func toggle() -> void:
	if _is_closed():
		_open()
	else:
		_close()


func _on_area_entered(_body: Node2D) -> void:
	if _is_closed():
		SoundManager.play_sfx_stream(SoundManager.sfx_stream_door_locked, global_position)


func _on_area_exited(_body: Node2D) -> void:
	pass
