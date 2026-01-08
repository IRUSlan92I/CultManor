class_name MainMenu
extends Control


@onready var start_button : Button = $%StartButton
@onready var options_button : Button = $%OptionsButton
@onready var quit_button : Button = $%QuitButton


func _ready() -> void:
	_init_focus()
	_setup_neighbors()


func _init_focus() -> void:
	start_button.grab_focus()


func _setup_neighbors() -> void:
	start_button.focus_neighbor_top = quit_button.get_path()
	quit_button.focus_neighbor_bottom = start_button.get_path()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/menu/level_selection.tscn")


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/menu/options_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
