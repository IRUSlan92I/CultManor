class_name AbstractActivatableObject
extends Node2D


@onready var hint_sprite : Sprite2D = $HintSprite


var _player_in_range := false


func _ready() -> void:
	hint_sprite.hide()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		hint_sprite.show()
		_player_in_range = true
		body.interacted.connect(_activate)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		hint_sprite.hide()
		_player_in_range = false
		body.interacted.disconnect(_activate)


func _activate() -> void:
	pass
