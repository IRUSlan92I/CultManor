class_name GameOverMenu
extends Control


@onready var main_menu_button : Button = $%MainMenuButton
@onready var focus_timer : Timer = $FocusTimer


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/menu/main_menu.tscn")


func _on_visibility_changed() -> void:
	if visible:
		if focus_timer != null:
			focus_timer.start()


func _on_focus_timer_timeout() -> void:
	if main_menu_button != null:
			main_menu_button.grab_focus()
