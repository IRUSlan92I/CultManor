class_name AbstractLevel
extends Node2D


@onready var pause_menu : PauseMenu = $%PauseMenu
@onready var game_over_menu : GameOverMenu = $%GameOverMenu


func _ready() -> void:
	pause_menu.hide()
	game_over_menu.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()


func _on_player_dead() -> void:
	get_tree().paused = true
	game_over_menu.show()
