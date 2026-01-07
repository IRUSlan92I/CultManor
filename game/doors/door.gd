class_name Door
extends Node2D


const ANIMATION_CLOSED = "closed"
const ANIMATION_OPEN = "open"
const ANIMATION_OPENING = "opening"


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var static_body : StaticBody2D = $StaticBody2D
@onready var static_body_collision : CollisionShape2D = $%StaticBodyCollision
@onready var area_collision : CollisionShape2D = $%AreaCollision


func _ready() -> void:
	sprite.play(ANIMATION_CLOSED)


func _is_closed() -> bool:
	return sprite.animation == ANIMATION_CLOSED


func _can_open(_body: Node2D) -> bool:
	return true


func _open() -> void:
	sprite.play(ANIMATION_OPENING)
	static_body.process_mode = Node.PROCESS_MODE_DISABLED


func _on_animation_finished() -> void:
	sprite.play(ANIMATION_OPEN)


func _on_area_entered(body: Node2D) -> void:
	if _is_closed() and _can_open(body):
		_open()
