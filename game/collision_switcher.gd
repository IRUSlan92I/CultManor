@tool
class_name CollisionSwitcher
extends Node


signal switched(new_color: CollisionSwitcher.ObjectColor)


enum ObjectColor {
	White,
	Black,
}


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

const MIN_INTENSITY = 0.0
const MAX_INTENSITY = 1.0

const SHADER_SWITCH_COLORS = "shader_parameter/switch_colors"
const SHADER_INTENSITY = "shader_parameter/intensity"


@export var objects : Array[CollisionObject2D] = []

@export var initial_state := State.White


var _materials : Array[Material]


var _state : State:
	set(value):
		_state = value
		if is_node_ready():
			_apply_color()

var _intensity_tween : Tween

var _grey_layers : Dictionary[CollisionObject2D, int] = {}
var _color_layers : Dictionary[CollisionObject2D, int] = {}

var _grey_masks : Dictionary[CollisionObject2D, int] = {}
var _color_masks : Dictionary[CollisionObject2D, int] = {}


func _ready() -> void:
	for object in objects:
		_grey_layers[object] = _get_grey_collision(object.collision_layer)
		_color_layers[object] = _get_color_collision(object.collision_layer)
		_grey_masks[object] = _get_grey_collision(object.collision_mask)
		_color_masks[object] = _get_color_collision(object.collision_mask)
	
	_state = initial_state
	
	_apply_color()


func add_material(material: Material) -> void:
	_materials.append(material)
	_apply_color_to_material(material)


func switch_color(switch_time := 0.0) -> void:
	if _intensity_tween != null and _intensity_tween.is_running(): return #TODO
	
	if is_zero_approx(switch_time):
		_state = State.Black if _state == State.White else State.White
		_emit_switch_signal()
	else:
		_state = State.TransitionToBlack if _state == State.White else State.TransitionToWhite
		
		_intensity_tween = create_tween()
		_intensity_tween.tween_method(_set_shader_internsity, 0.0, MAX_INTENSITY, switch_time) \
			.set_ease(Tween.EASE_OUT_IN) \
			.set_trans(Tween.TRANS_SINE)
		_intensity_tween.finished.connect(_update_state)


func _get_grey_collision(collision: int) -> int:
	return collision & Collisions.GREY


func _get_color_collision(collision: int) -> int:
	var black_collision := collision & Collisions.BLACK
	var white_collision := (collision & Collisions.WHITE) >> COLLISION_WHITE_SHIFT
	return black_collision | white_collision


func _set_shader_internsity(value: float) -> void:
	for material in _materials:
		material.set(SHADER_INTENSITY, value)


func _update_state() -> void:
	match _state:
		State.TransitionToBlack:
			_state = State.Black
		State.TransitionToWhite:
			_state = State.White
	_emit_switch_signal()


func _apply_color() -> void:
	for object in objects:
		_apply_color_to_object(object)
	
	for material in _materials:
		_apply_color_to_material(material)


func _apply_color_to_object(object: CollisionObject2D) -> void:
	var layer := 0
	var mask := 0
	var grey_layer := _grey_layers[object]
	var color_layer := _color_layers[object]
	var grey_mask := _grey_masks[object]
	var color_mask := _color_masks[object]
	
	match _state:
		State.Black:
			layer = grey_layer | color_layer
			mask = grey_mask | color_mask
		State.White:
			layer = grey_layer | (color_layer << COLLISION_WHITE_SHIFT)
			mask = grey_mask | (color_mask << COLLISION_WHITE_SHIFT)
		State.TransitionToBlack, State.TransitionToWhite:
			layer = grey_layer | color_layer | (color_layer << COLLISION_WHITE_SHIFT)
			mask = grey_mask | color_mask | (color_mask << COLLISION_WHITE_SHIFT)
	
	object.collision_layer = layer
	object.collision_mask = mask


func _apply_color_to_material(material: Material) -> void:
	var is_black := _state == State.Black or _state == State.TransitionToBlack
	material.set(SHADER_SWITCH_COLORS, is_black)


func _emit_switch_signal() -> void:
	var color : ObjectColor
	match _state:
		State.White:
			color = ObjectColor.White
		State.Black:
			color = ObjectColor.Black
		_:
			return
	switched.emit(color)
