class_name CSettingsManager
extends Node


@export var config_file_path := "user://settings.cfg"
@export var window_base_size := Vector2i(640, 360)


const CATEGORY_VIDEO = "video"
const SETTING_FULLSCREEN = "fullscreen"
const SETTING_WINDOW_FACTOR = "window_factor"
const CATEGORY_AUDIO = "audio"
const SETTING_MASTER_VOLUME = "master_volume"
const SETTING_UI_VOLUME = "ui_volume"
const SETTING_SFX_VOLUME = "sfx_volume"
const SETTING_MUSIC_VOLUME = "music_volume"


var _config: ConfigFile

var _fullscreen := false
var fullscreen : bool:
	get():
		return _fullscreen
	set(value):
		_fullscreen = value
		_apply_video_settings()
		_save_settings()

var _window_factor := 1
var window_factor : int:
	get():
		return _window_factor
	set(value):
		_window_factor = clampi(value, 1, 5)
		_apply_video_settings()
		_save_settings()

var _master_volume := 100
var master_volume : int:
	get():
		return _master_volume
	set(value):
		_master_volume = clampi(value, 0, 100)
		_apply_audio_settings()
		_save_settings()

var _ui_volume := 100
var ui_volume : int:
	get():
		return _ui_volume
	set(value):
		_ui_volume = clampi(value, 0, 100)
		_apply_audio_settings()
		_save_settings()

var _sfx_volume := 100
var sfx_volume : int:
	get():
		return _sfx_volume
	set(value):
		_sfx_volume = clampi(value, 0, 100)
		_apply_audio_settings()
		_save_settings()

var _music_volume := 100
var music_volume : int:
	get():
		return _music_volume
	set(value):
		_music_volume = clampi(value, 0, 100)
		_apply_audio_settings()
		_save_settings()


func _ready() -> void:
	_config = ConfigFile.new()
	
	_load_settings()
	_apply_all_settings()


func _load_settings() -> void:
	if _config.load(config_file_path) == OK:
		_fullscreen = _config.get_value(CATEGORY_VIDEO, SETTING_FULLSCREEN, _fullscreen)
		_window_factor = _config.get_value(CATEGORY_VIDEO, SETTING_WINDOW_FACTOR, _window_factor)
		
		_master_volume = _config.get_value(CATEGORY_AUDIO, SETTING_MASTER_VOLUME, _master_volume)
		_ui_volume = _config.get_value(CATEGORY_AUDIO, SETTING_UI_VOLUME, _ui_volume)
		_sfx_volume = _config.get_value(CATEGORY_AUDIO, SETTING_SFX_VOLUME, _sfx_volume)
		_music_volume = _config.get_value(CATEGORY_AUDIO, SETTING_MUSIC_VOLUME, _music_volume)
	
	_save_settings()


func _save_settings() -> void:
	if _config == null:
		_config = ConfigFile.new()
	
	_config.set_value(CATEGORY_VIDEO, SETTING_FULLSCREEN, _fullscreen)
	_config.set_value(CATEGORY_VIDEO, SETTING_WINDOW_FACTOR, _window_factor)
	
	_config.set_value(CATEGORY_AUDIO, SETTING_MASTER_VOLUME, _master_volume)
	_config.set_value(CATEGORY_AUDIO, SETTING_UI_VOLUME, _ui_volume)
	_config.set_value(CATEGORY_AUDIO, SETTING_SFX_VOLUME, _sfx_volume)
	_config.set_value(CATEGORY_AUDIO, SETTING_MUSIC_VOLUME, _music_volume)
	
	_config.save(config_file_path)


func _apply_all_settings() -> void:
	_apply_video_settings()
	_apply_audio_settings()


func _apply_video_settings() -> void:
	if _fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_apply_window_scale()


func _apply_audio_settings() -> void:
	var master_bus := AudioServer.get_bus_index(CSoundManager.MASTER_BUS)
	var ui_bus := AudioServer.get_bus_index(CSoundManager.UI_BUS)
	var sfx_bus := AudioServer.get_bus_index(CSoundManager.SFX_BUS)
	var music_bus := AudioServer.get_bus_index(CSoundManager.MUSIC_BUS)
	
	AudioServer.set_bus_volume_linear(master_bus, _master_volume/100.0)
	AudioServer.set_bus_volume_linear(ui_bus, _ui_volume/100.0)
	AudioServer.set_bus_volume_linear(sfx_bus, _sfx_volume/100.0)
	AudioServer.set_bus_volume_linear(music_bus, _music_volume/100.0)


func _apply_window_scale() -> void:
	if _fullscreen: return
	
	var new_size := window_base_size * _window_factor
		
	var current_position := DisplayServer.window_get_position()
	var current_size := DisplayServer.window_get_size()
	
	var current_center := current_position + current_size / 2
	var new_position := current_center - new_size / 2
	
	DisplayServer.window_set_size(new_size)
	DisplayServer.window_set_position(new_position)
	
	_ensure_window_on_screen()


func _ensure_window_on_screen() -> void:
	if _fullscreen: return
	
	var window_position := DisplayServer.window_get_position()
	var window_size := DisplayServer.window_get_size()
	var screen_size := DisplayServer.screen_get_size()
	
	var new_x : int = clamp(window_position.x, 0, screen_size.x - window_size.x)
	var new_y : int = clamp(window_position.y, 0, screen_size.y - window_size.y)
	
	if new_x != window_position.x or new_y != window_position.y:
		DisplayServer.window_set_position(Vector2i(new_x, new_y))
