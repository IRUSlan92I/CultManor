@tool
class_name MovingPlatform
extends AbstractPlatform


enum Type {
	SelfMoving,
	LeftRight,
	RightLeft,
	UpDown,
	DownUp,
}


const ANIMATION_MAP : Dictionary[Type, Dictionary] = {
	Type.LeftRight: { false: ANIMATION_MOVING_LEFT, true: ANIMATION_MOVING_RIGHT },
	Type.RightLeft: { false: ANIMATION_MOVING_RIGHT, true: ANIMATION_MOVING_LEFT },
	Type.UpDown:    { false: ANIMATION_MOVING_UP,  true: ANIMATION_MOVING_DOWN },
	Type.DownUp:    { false: ANIMATION_MOVING_DOWN,  true: ANIMATION_MOVING_UP },
}


@export var is_loop := false
@export var path : Path2D
@export var path_follow : PathFollow2D
@export_range(0, 25, 0.1) var speed : float = 10.0
@export var type := Type.SelfMoving:
	set(value):
		type = value
		if is_node_ready():
			_initialize_platform()


var is_moving := false
var is_reverse := false
var tween: Tween


@onready var invert_timer : Timer = $InvertTimer


func _ready() -> void:
	super._ready()
	_initialize_platform()


func toggle() -> void:
	if type == Type.SelfMoving: return
	
	if is_moving:
		_stop_movement()
	else:
		_start_movement()


func _initialize_platform() -> void:
	if not Engine.is_editor_hint() and type == Type.SelfMoving:
		_start_movement()
	else:
		_select_animation()


func _select_animation() -> void:
	if type == Type.SelfMoving:
		if not icon_sprite.is_playing():
			icon_sprite.play(ANIMATION_SELF_MOVING)
		return
	
	var direction : String = ANIMATION_MAP[type][not is_reverse]
	var suffix := ANIMATION_ACTIVE_SUFFIX if is_moving else ANIMATION_STATIC_SUFFIX
	icon_sprite.play(ANIMATION_MOVING_PREFIX + direction + suffix)


func _start_movement() -> void:
	is_moving = true
	if tween and tween.is_running():
		tween.kill()
	_select_animation()
	
	var target_progress := 0.0 if is_reverse else path.curve.get_baked_length()
	var distance := absf(target_progress - path_follow.progress)
	var duration := distance / speed
	
	tween = create_tween()
	var target_ratio := 0.0 if is_reverse else 1.0
	tween.tween_property(path_follow, "progress_ratio", target_ratio, duration)
	tween.finished.connect(_invert_movement)


func _stop_movement() -> void:
	is_moving = false
	if tween and tween.is_running():
		tween.kill()
	if not invert_timer.is_stopped():
		invert_timer.stop()
	_select_animation()


func _invert_movement() -> void:
	if is_loop:
		path_follow.progress_ratio = 0
	else:
		is_reverse = not is_reverse
	
	_select_animation()
	invert_timer.start()
