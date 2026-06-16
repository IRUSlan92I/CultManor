class_name ConnectionCable
extends Line2D


const SHADER_GLOW_INTERVAL = "shader_parameter/glow_interval"
const SHADER_GLOW_RADIUS = "shader_parameter/glow_radius"
const SHADER_TRAVEL_TIME = "shader_parameter/travel_time"

const TRAVEL_SPEED_ON = 150.0
const TRAVEL_SPEED_OFF = 75.0
const GLOW_INTERVAL = 100.0

const SWITCH_TIME = 0.15


@export var is_on := false:
	set(value):
		is_on = value
		if is_node_ready():
			_play_toggle_animation()


var _shader_tween : Tween


@onready var length := _get_length()
@onready var glow_interval := 1.0 / maxi(1, round(length/GLOW_INTERVAL))
@onready var glow_radius := 0.5/length
@onready var travel_time_on := _get_travel_time(TRAVEL_SPEED_ON)
@onready var travel_time_off := _get_travel_time(TRAVEL_SPEED_OFF)


func _ready() -> void:
	material.set(SHADER_GLOW_INTERVAL, glow_interval)
	material.set(SHADER_GLOW_RADIUS, glow_radius)
	material.set(SHADER_TRAVEL_TIME, _get_current_travel_time())


func toggle() -> void:
	is_on = not is_on


func _play_toggle_animation() -> void:
	if _shader_tween and _shader_tween.is_running():
		_shader_tween.kill()
	_shader_tween = create_tween()
	
	_shader_tween.tween_property(material, SHADER_GLOW_RADIUS, glow_interval, SWITCH_TIME)
	_shader_tween.tween_property(material, SHADER_TRAVEL_TIME, _get_current_travel_time(), 0.0)
	_shader_tween.tween_property(material, SHADER_GLOW_RADIUS, glow_radius, SWITCH_TIME)


func _get_length() -> float:
	if points.size() < 2:
		return 0.0
	
	var l := 0.0
	for i in range(points.size() - 1):
		l += points[i].distance_to(points[i + 1])
	return l


func _get_travel_time(speed: float) -> float:
	return length/speed


func _get_current_travel_time() -> float:
	return travel_time_on if is_on else travel_time_off
