extends AbstractLevel


const CUTSCENE_CAMERA_TIME = 5
const CUTSCENE_HAZE_TIME = 0.1

const CUTSCENE_HAZE_TIME_BY_PHASE : Dictionary[int, float] = {
	1: CUTSCENE_HAZE_TIME,
	3: CUTSCENE_HAZE_TIME,
	5: CUTSCENE_HAZE_TIME,
	7: CUTSCENE_HAZE_TIME,
}


var _cutscene_phase := 0
var _player_walk_speed : int
var _cutscene_player_speed_factor := 0.5

var _function_by_phase : Dictionary[int, Callable] = {
	1: _do_cutscene_phase_one,
	4: _do_cutscene_phase_four,
	6: _do_cutscene_phase_six,
	7: _do_cutscene_phase_seven,
}


@onready var cutscene_camera : Camera2D = $Cutscene/Camera2D
@onready var cutscene_haze : Polygon2D = $%CutsceneHaze
@onready var cutscene_thanks : Label = $CanvasLayer/MarginContainer/ThanksLabel

@onready var cutscene_haze_timer : Timer = $Cutscene/HazeTimer
@onready var cutscene_player_timer : Timer = $Cutscene/PlayerTimer
@onready var cutscene_enemy_timer : Timer = $Cutscene/EnemyTimer
@onready var cutscene_end_timer : Timer = $Cutscene/EndTimer

@onready var cutscene_fake_player : AnimatedSprite2D = $Cutscene/FakePlayer
@onready var cutscene_fake_enemy : AnimatedSprite2D = $Cutscene/FakeEnemy

@onready var enemy_waves_by_phase : Dictionary[int, Node2D] = {
	3: $Cutscene/EnemyWaves/WaveOne,
	5: $Cutscene/EnemyWaves/WaveTwo,
	7: $Cutscene/EnemyWaves/WaveThree,
}

@onready var cutscene_room_center : Vector2 = $Cutscene/RoomCenter.position
@onready var PLAYER_TARGET_POSITION_BY_PHASE : Dictionary[int, Vector2] = {
	1: $Cutscene/PlayerTargetPositions/PhaseOne.global_position,
	2: $Cutscene/PlayerTargetPositions/PhaseTwo.global_position,
	3: $Cutscene/PlayerTargetPositions/PhaseThree.global_position,
	4: $Cutscene/PlayerTargetPositions/PhaseFour.global_position,
	5: $Cutscene/PlayerTargetPositions/PhaseFive.global_position,
	6: $Cutscene/FakeEnemy.global_position,
}


func _ready() -> void:
	super._ready()
	_player_walk_speed = player.max_speed
	cutscene_haze.hide()
	cutscene_fake_player.hide()
	cutscene_fake_enemy.hide()
	cutscene_thanks.hide()
	for phase in enemy_waves_by_phase:
		enemy_waves_by_phase[phase].hide()


func _show_cutscene_haze(time: float) -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_haze, cutscene_room_center)
	cutscene_haze.show()
	cutscene_haze_timer.start(time)


func _next_cutscene_phase() -> void:
	_cutscene_phase += 1
	
	if _function_by_phase.has(_cutscene_phase):
		_function_by_phase[_cutscene_phase].call()
	
	if CUTSCENE_HAZE_TIME_BY_PHASE.has(_cutscene_phase):
		_show_cutscene_haze(CUTSCENE_HAZE_TIME_BY_PHASE[_cutscene_phase])
	
	if enemy_waves_by_phase.has(_cutscene_phase):
		enemy_waves_by_phase[_cutscene_phase].show()
	
	if PLAYER_TARGET_POSITION_BY_PHASE.has(_cutscene_phase):
		var target_pos := PLAYER_TARGET_POSITION_BY_PHASE[_cutscene_phase]
		var time := _get_player_move_time(cutscene_fake_player.position, target_pos)
		var tween : Tween = create_tween()
		tween.tween_property(cutscene_fake_player, "position", target_pos, time)
		tween.finished.connect(_next_cutscene_phase)


func _do_cutscene_phase_one() -> void:
	player.queue_free()
	cutscene_camera.position = player.position
	cutscene_camera.enabled = true
	cutscene_camera.make_current()
	cutscene_fake_player.show()
	cutscene_fake_player.play(Player.ANIMATION_WALK_RIGHT, _cutscene_player_speed_factor)
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(cutscene_camera, "position", cutscene_room_center, CUTSCENE_CAMERA_TIME)


func _do_cutscene_phase_four() -> void:
	cutscene_fake_player.play(Player.ANIMATION_WALK_LEFT,_cutscene_player_speed_factor)


func _do_cutscene_phase_six() -> void:
	_cutscene_player_speed_factor = 0.25
	cutscene_fake_player.play(Player.ANIMATION_WALK_RIGHT, _cutscene_player_speed_factor)


func _do_cutscene_phase_seven() -> void:
	cutscene_fake_player.play("look_around", 0.5)
	cutscene_player_timer.start()


func _get_player_move_time(initial_pos: Vector2, target_pos: Vector2) -> float:
	var distance := initial_pos.distance_to(target_pos)
	return distance / (_player_walk_speed * _cutscene_player_speed_factor)


func _on_level_end_entered(body: Node2D) -> void:
	if body is Player:
		_next_cutscene_phase()


func _on_haze_timer_timeout() -> void:
	cutscene_haze.hide()


func _on_player_timer_timeout() -> void:
	_show_cutscene_haze(CUTSCENE_HAZE_TIME)
	cutscene_fake_player.queue_free()
	cutscene_fake_enemy.show()
	cutscene_fake_enemy.play("look_around", 0.5)
	cutscene_enemy_timer.start()


func _on_enemy_timer_timeout() -> void:
	cutscene_thanks.show()
	cutscene_end_timer.start()


func _on_end_timer_timeout() -> void:
	_complete_level(cutscene_room_center)
