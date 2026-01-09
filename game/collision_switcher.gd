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
}


const COLLISION_WHITE_SHIFT = 4

const SHADER_SWITCH_COLORS = "shader_parameter/switch_colors"


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


func switch_color() -> void:
	_state = State.Black if _state == State.White else State.White



func _get_grey_collision(collision: int) -> int:
	return collision & Collisions.GREY


func _get_color_collision(collision: int) -> int:
	var black_collision := collision & Collisions.BLACK
	var white_collision := (collision & Collisions.WHITE) >> COLLISION_WHITE_SHIFT
	return black_collision | white_collision


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
	
	object.collision_layer = layer
	object.collision_mask = mask
	
	if material != null:
		var is_black := _state == State.Black
		material.set(SHADER_SWITCH_COLORS, is_black)
