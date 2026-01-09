class_name CollisionSwitcher
extends Node


enum Collisions {
	GREY_WORLD = 1 << 0,
	GREY_ENEMY = 1 << 4,
	
	BLACK_WORLD = 1 << 1,
	BLACK_ENEMY = 1 << 2,
	BLACK_PLAYER = 1 << 3,
	
	WHITE_WORLD = 1 << 5,
	WHITE_ENEMY = 1 << 6,
	WHITE_PLAYER = 1 << 7,
	
	GREY = GREY_WORLD | GREY_ENEMY,
	BLACK = BLACK_WORLD | BLACK_ENEMY | BLACK_PLAYER,
	WHITE = WHITE_WORLD | WHITE_ENEMY | WHITE_PLAYER,
}

enum State {
	Black,
	White,
	TransitionToBlack,
	TransitionToWhite,
}


const COLLISION_WHITE_SHIFT = 4

const MAX_INTENSITY = 1.0

const SHADER_SWITCH_COLORS = "shader_parameter/switch_colors"
const SHADER_INTENSITY = "shader_parameter/intensity"


@export var object : CollisionObject2D

@export var initial_state : State = State.White


var material : Material:
	set(value):
		material = value
		_apply_color()

var _state : State:
	set(value):
		_state = value
		_apply_color()

var _intensity_tween : Tween

var _grey_layer := 0
var _color_layer := 0

var _grey_mask := 0
var _color_mask := 0


func _ready() -> void:
	_grey_layer = _get_grey_collision(object.collision_layer)
	_color_layer = _get_color_collision(object.collision_layer)
	
	_grey_mask = _get_grey_collision(object.collision_mask)
	_color_mask = _get_color_collision(object.collision_mask)
	
	_state = initial_state


func switch_color(time: float = 0.0) -> void:
	if _intensity_tween != null and _intensity_tween.is_running(): return
	
	if is_zero_approx(time):
		_state = State.Black if _state == State.White else State.White
	else:
		_state = State.TransitionToBlack if _state == State.White else State.TransitionToWhite
		
		_intensity_tween = create_tween()
		_intensity_tween.tween_method(_set_shader_internsity, 0.0, MAX_INTENSITY, time)
		_intensity_tween.finished.connect(_update_state)


func _get_grey_collision(collision: int) -> int:
	return collision & Collisions.GREY


func _get_color_collision(collision: int) -> int:
	var black_collision := collision & Collisions.BLACK
	var white_collision := (collision & Collisions.WHITE) >> COLLISION_WHITE_SHIFT
	return black_collision | white_collision


func _set_shader_internsity(value: float) -> void:
	material.set(SHADER_INTENSITY, value)


func _update_state() -> void:
	match _state:
		State.TransitionToBlack:
			_state = State.Black
		State.TransitionToWhite:
			_state = State.White


func _apply_color() -> void:
	var layer := 0
	var mask := 0
	
	match _state:
		State.Black:
			layer = _grey_layer | _color_layer
			mask = _grey_mask | _color_mask
		State.White:
			layer = _grey_layer | (_color_layer << COLLISION_WHITE_SHIFT)
			mask = _grey_mask | (_color_mask << COLLISION_WHITE_SHIFT)
		State.TransitionToBlack, State.TransitionToWhite:
			layer = _grey_layer | _color_layer | (_color_layer << COLLISION_WHITE_SHIFT)
			mask = _grey_mask
	
	object.collision_layer = layer
	object.collision_mask = mask
	
	if material != null:
		var is_black := _state == State.Black or _state == State.TransitionToBlack
		material.set(SHADER_SWITCH_COLORS, is_black)
