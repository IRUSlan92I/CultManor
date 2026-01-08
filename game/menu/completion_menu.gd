class_name CompletionMenu
extends Control


@export var next_level : PackedScene


@onready var next_level_button : Button = $%NextLevelButton
@onready var focus_timer : Timer = $FocusTimer


func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	
	if next_level != null:
		get_tree().change_scene_to_packed(next_level)
	else:
		get_tree().change_scene_to_file("res://game/menu/main_menu.tscn")


func _on_visibility_changed() -> void:
	if visible:
		if focus_timer != null:
			focus_timer.start()


func _on_focus_timer_timeout() -> void:
	if next_level_button != null:
			next_level_button.grab_focus()
