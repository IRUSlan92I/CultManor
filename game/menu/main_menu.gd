class_name MainMenu
extends Control


@onready var start_button : Button = $%StartButton
@onready var options_button : Button = $%OptionsButton
@onready var quit_button : Button = $%QuitButton


func _ready() -> void:
	start_button.grab_focus()
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)


func _on_gui_focus_changed(_node: Control) -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_select)


func _on_start_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	get_tree().change_scene_to_file("res://game/menu/level_selection.tscn")


func _on_options_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	get_tree().change_scene_to_file("res://game/menu/options_menu.tscn")


func _on_quit_button_pressed() -> void:
	var stream_player := SoundManager.play_ui_stream(SoundManager.ui_stream_decline)
	await stream_player.finished
	get_tree().quit()
