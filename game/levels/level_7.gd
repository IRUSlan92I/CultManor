extends AbstractLevel


const ANIMATION_NAME = "final_cutscene"


@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var fake_player : PlayerSprite = $Cutscene/FakePlayer
@onready var fake_cultist : CultistSprite = $Cutscene/FakeCultist
@onready var cutscene_camera : Camera2D = $Cutscene/Camera2D

@onready var cutscene_room_center : Vector2 = $Cutscene/RoomCenter.position


func _ready() -> void:
	$CanvasLayer/MarginContainer/ThanksLabel.hide()
	animation_player.play("hide_cutscene_elements")
	super._ready()


func _on_level_end_entered(body: Node2D) -> void:
	if body is Player:
		_play_cutscene()


func _play_cutscene() -> void:
	var camera_track_name := "Cutscene/Camera2D:position"
	var player_track_name := "Cutscene/FakePlayer:position"
	
	var animation := animation_player.get_animation(ANIMATION_NAME)
	var camera_track := animation.find_track(camera_track_name, Animation.TYPE_VALUE)
	var player_track := animation.find_track(player_track_name, Animation.TYPE_VALUE)
	
	animation.track_set_key_value(camera_track, 0, player.camera.get_screen_center_position())
	animation.track_set_key_value(player_track, 0, player.position)
	
	player.queue_free()
	cutscene_camera.enabled = true
	cutscene_camera.make_current()
	animation_player.play(ANIMATION_NAME)


func _play_cutscene_boop() -> void:
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_haze, cutscene_room_center)


func _play_fake_cultist_animation() -> void:
	fake_cultist.animated_sprite.play(CultistSprite.ANIMATION_LOOK_AROUND, 0.5)


func _make_fake_cultist_grey() -> void:
	var tween := create_tween()
	tween.tween_property(fake_cultist.material, CultistSprite.SHADER_INTENSITY, 0.5, 5)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "final_cutscene":
		_complete_level(cutscene_room_center)
