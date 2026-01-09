class_name AbstractPickup
extends Area2D


func _play_pickup_sound() -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_key_picked_up, global_position)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_pickup"):
		collision_mask = 0
		body.add_pickup(self)
		_play_pickup_sound()
