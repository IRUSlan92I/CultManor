class_name CompletionMenu
extends Control


@onready var next_level_button : Button = $%NextLevelButton
@onready var main_menu_button : Button = $%MainMenuButton
@onready var focus_timer : Timer = $FocusTimer


func _get_next_level(remove := false) -> PackedScene:
	var next_level : PackedScene = get_tree().get_meta(AbstractLevel.NEXT_LEVEL_META, null)
	
	if remove:
		get_tree().remove_meta(AbstractLevel.NEXT_LEVEL_META)
	
	return next_level


func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(_get_next_level(true))


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/menu/main_menu.tscn")


func _on_visibility_changed() -> void:
	if visible:
		next_level_button.visible = _get_next_level() != null
		if focus_timer != null:
			focus_timer.start()


func _on_focus_timer_timeout() -> void:
	if next_level_button != null and next_level_button.visible:
		next_level_button.grab_focus()
	elif main_menu_button != null:
		main_menu_button.grab_focus()
