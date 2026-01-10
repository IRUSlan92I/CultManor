class_name Door
extends Node2D


const ANIMATION_CLOSED = "closed"
const ANIMATION_OPEN = "open"
const ANIMATION_OPENING = "opening"
const ANIMATION_CLOSING = "closing"


var _needed_to_be_open := false
var _needed_to_be_closed := false


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var static_body : StaticBody2D = $StaticBody2D
@onready var static_body_collision : CollisionShape2D = $%StaticBodyCollision
@onready var area_collision : CollisionShape2D = $%AreaCollision


func _ready() -> void:
	sprite.play(ANIMATION_CLOSED)


func _is_open() -> bool:
	return sprite.animation == ANIMATION_OPEN


func _is_closed() -> bool:
	return sprite.animation == ANIMATION_CLOSED


func _can_open(_body: Node2D) -> bool:
	return true


func _can_close(_body: Node2D) -> bool:
	return true


func _open() -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_door_opening, global_position)
	sprite.play(ANIMATION_OPENING)
	static_body.process_mode = Node.PROCESS_MODE_DISABLED


func _close() -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_door_closing, global_position)
	sprite.play(ANIMATION_CLOSING)
	static_body.process_mode = Node.PROCESS_MODE_INHERIT


func _on_animation_finished() -> void:
	match sprite.animation:
		ANIMATION_OPENING:
			_needed_to_be_open = false
			if _needed_to_be_closed:
				_close()
			else:
				sprite.play(ANIMATION_OPEN)
		ANIMATION_CLOSING:
			_needed_to_be_closed = false
			if _needed_to_be_open:
				_open()
			else:
				sprite.play(ANIMATION_CLOSED)
			pass


func _on_area_entered(body: Node2D) -> void:
	if _can_open(body):
		if _is_closed():
			_open()
		else:
			_needed_to_be_open = true
	else:
		SoundManager.play_sfx_stream(SoundManager.sfx_stream_door_locked, global_position)


func _on_area_exited(body: Node2D) -> void:
	if _can_close(body):
		if _is_open():
			_close()
		else:
			_needed_to_be_closed = true
