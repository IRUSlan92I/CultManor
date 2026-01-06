class_name PauseMenu
extends Control


@onready var continue_button : Button = $%ContinueButton
@onready var main_menu_button : Button = $%MainMenuButton


func _ready() -> void:
	_init_focus()
	_setup_neighbors()


func _init_focus() -> void:
	continue_button.grab_focus()


func _setup_neighbors() -> void:
	continue_button.focus_neighbor_top = main_menu_button.get_path()
	main_menu_button.focus_neighbor_bottom = continue_button.get_path()


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/menu/main_menu.tscn")


func _on_visibility_changed() -> void:
	if visible:
		if continue_button != null:
			continue_button.grab_focus()
