class_name AbstractActivatableObject
extends Node2D


@onready var hover_tip : Node2D = $HoverTip


var _player_in_range := false


func _ready() -> void:
	hover_tip.hide()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		hover_tip.show()
		_player_in_range = true
		body.interacted.connect(_activate)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		hover_tip.hide()
		_player_in_range = false
		body.interacted.disconnect(_activate)


func _activate() -> void:
	pass
