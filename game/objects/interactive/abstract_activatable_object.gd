class_name AbstractActivatableObject
extends Node2D


@onready var hint_sprite : Sprite2D = $HintSprite


func activate() -> void:
	pass


func _ready() -> void:
	hint_sprite.hide()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		hint_sprite.show()
		body.interacted.connect(activate)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		hint_sprite.hide()
		body.interacted.disconnect(activate)
