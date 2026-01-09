class_name BookPickup
extends AbstractPickup


func _play_pickup_sound() -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_book_picked_up, global_position)
