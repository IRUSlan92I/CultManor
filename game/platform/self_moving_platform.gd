@tool
class_name SelfMovingPlatform
extends AbstractPlatform


const SPEED_FACTOR = 0.025
const ANIMATION_ACTIVE = "active"


@export var is_loop := false
@export var path_follow : PathFollow2D
@export_range(0, 25, 0.1) var speed : float = 10.0


var is_reverse := false
var tween: Tween


func _ready() -> void:
	super._ready()
	icon_sprite.play(ANIMATION_ACTIVE)
	if not Engine.is_editor_hint():
		_start_movement()


func _start_movement() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	var target := 0.0 if is_reverse else 1.0
	var distance := absf(target - path_follow.progress_ratio)
	var duration := distance / (speed * SPEED_FACTOR)
	
	tween = create_tween()
	
	if not is_loop:
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_tween_finished)
	
	tween.tween_property(path_follow, "progress_ratio", target, duration)


func _on_tween_finished() -> void:
	if is_loop:
		path_follow.progress_ratio = 0
	else:
		is_reverse = not is_reverse
	
	_start_movement()
