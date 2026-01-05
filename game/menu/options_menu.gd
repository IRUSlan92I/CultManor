class_name OptionsMenu
extends Control


const WINDOW_FACTOR = "window_factor"


signal back


@onready var fullscreen_button : CheckButton = $%FullscreenCheckButton
@onready var window_factor_buttons : HBoxContainer = $%WindowFactorContainer
@onready var back_button : Button = $%BackButton
@onready var master_slider : Slider = $%MasterSlider
@onready var ui_slider : Slider = $%UISlider
@onready var sfx_slider : Slider = $%SFXSlider
@onready var music_slider : Slider = $%MusicSlider


func _ready() -> void:
	_connect_window_factor_buttons()
	_load_current_settings()
	_init_focus()
	_setup_neighbors()


func _play_left_sound() -> bool:
	return _play_side_sound(1, 0)


func _play_right_sound() -> bool:
	return _play_side_sound(0, 1)


func _play_side_sound(offset_begin: int, offset_end: int) -> bool:
	for i in range(offset_begin, window_factor_buttons.get_child_count() - offset_end):
		var child := window_factor_buttons.get_child(i)
		if child is Button and child.has_focus():
			return true
	return false


func _connect_window_factor_buttons() -> void:
	for child in window_factor_buttons.get_children():
		if child is Button:
			var button : Button = child
			button.pressed.connect(_on_window_factor_button_pressed.bind(button))


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	_load_current_settings()
	_init_focus()
	_setup_neighbors()


func _init_focus() -> void:
	fullscreen_button.grab_focus()


func _setup_neighbors() -> void:
	music_slider.focus_neighbor_bottom = back_button.get_path()


func _load_current_settings() -> void:
	fullscreen_button.button_pressed = SettingsManager.fullscreen
	for child in window_factor_buttons.get_children():
		if child is Button:
			var button : Button = child
			var window_factor : int = button.get_meta(WINDOW_FACTOR, 0)
			if window_factor == SettingsManager.window_factor:
				button.button_pressed = true
	_update_window_factor_disabled()
	
	master_slider.value = SettingsManager.master_volume
	ui_slider.value = SettingsManager.ui_volume
	sfx_slider.value = SettingsManager.sfx_volume
	music_slider.value = SettingsManager.music_volume


func _update_window_factor_disabled() -> void:
	for child in window_factor_buttons.get_children():
		if not child is Button: continue
		child.disabled = SettingsManager.fullscreen
		child.focus_mode = Control.FOCUS_NONE if SettingsManager.fullscreen else Control.FOCUS_ALL


func _on_fullscreen_check_button_toggled(toggled: bool) -> void:
	SettingsManager.fullscreen = toggled
	_update_window_factor_disabled()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/menu/main_menu.tscn")


func _on_window_factor_button_pressed(button: Button) -> void:
	var window_factor : int = button.get_meta(WINDOW_FACTOR, 0)
	if window_factor > 0:
		SettingsManager.window_factor = window_factor


func _on_master_volume_changed(value: float) -> void:
	SettingsManager.master_volume = floor(value)


func _on_ui_volume_changed(value: float) -> void:
	SettingsManager.ui_volume = floor(value)


func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.sfx_volume = floor(value)


func _on_music_volume_changed(value: float) -> void:
	SettingsManager.music_volume = floor(value)
