class_name AbstractLevel
extends Node2D


@onready var pause_menu : PauseMenu = $%PauseMenu


func _ready() -> void:
	pause_menu.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()
