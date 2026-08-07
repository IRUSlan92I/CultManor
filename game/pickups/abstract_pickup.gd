class_name AbstractPickup
extends Area2D


const BOUNCE_SPEED = 250.0


@export_range(0.0, 100.0) var max_bounce_offset := 0.0


@onready var sprite : Sprite2D = $Sprite2D


func _process(_delta: float) -> void:
	sprite.position.y = round(sin(Time.get_ticks_msec() / BOUNCE_SPEED) * max_bounce_offset)


func _play_pickup_sound() -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_key_picked_up, global_position)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_pickup"):
		collision_mask = 0
		body.add_pickup(self)
		_play_pickup_sound()
