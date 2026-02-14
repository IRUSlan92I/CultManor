extends AbstractLevel


@onready var cutscene_haze : Polygon2D = $%CutsceneHaze
@onready var cutscene_haze_timer : Timer = $Cutscene/HazeTimer

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var cutscene_camera : Camera2D = $Cutscene/Camera2D

@onready var cutscene_room_center : Vector2 = $Cutscene/RoomCenter.position


func _ready() -> void:
	super._ready()
	animation_player.play("hide_cutscene_elements")


func _on_level_end_entered(body: Node2D) -> void:
	if body is Player:
		_play_cutscene()


func _play_cutscene() -> void:
	player.queue_free()
	cutscene_camera.enabled = true
	cutscene_camera.make_current()
	animation_player.play("final_cutscene")


func _show_cutscene_haze(time: float) -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_haze, cutscene_room_center)
	cutscene_haze.show()
	cutscene_haze_timer.start(time)


func _on_haze_timer_timeout() -> void:
	cutscene_haze.hide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "final_cutscene":
		_complete_level(cutscene_room_center)
