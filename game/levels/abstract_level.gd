class_name AbstractLevel
extends Node2D


@export var player_falling_at_start: bool = true


@onready var player : Player = $Player
@onready var pause_menu : PauseMenu = $%PauseMenu
@onready var game_over_menu : GameOverMenu = $%GameOverMenu
@onready var completion_menu : CompletionMenu = $%CompletionMenu


func _ready() -> void:
	pause_menu.hide()
	game_over_menu.hide()
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	SoundManager.play_music_stream(SoundManager.music_stream_gameplay)
	
	if player_falling_at_start:
		player.velocity.y = player.max_fall_speed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
		get_tree().paused = true
		pause_menu.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _complete_level(player_position: Vector2) -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_level_completed, player_position)
	get_tree().paused = true
	completion_menu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if SaveManager.completed_levels <= LevelManager.current_level_index:
		SaveManager.completed_levels = LevelManager.current_level_index + 1
		SaveManager.save()


func _on_player_dead() -> void:
	get_tree().paused = true
	game_over_menu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_level_end_entered(body: Node2D) -> void:
	if body is Player:
		_complete_level(player.global_position)
