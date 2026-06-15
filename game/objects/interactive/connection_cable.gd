class_name ConnectionCable
extends Line2D


const SHADER_GLOW_INTERVAL = "glow_interval"
const SHADER_GLOW_RADIUS = "glow_radius"
const SHADER_TRAVEL_TIME = "travel_time"

const TRAVEL_SPEED = 100.0
const GLOW_INTERVAL = 100.0


func _ready() -> void:
	var length := _get_length()
	var glow_interval := 1.0 / maxi(1, round(length/GLOW_INTERVAL))
	var glow_radius := 0.5/length
	var travel_time := length/TRAVEL_SPEED
	
	material.set_shader_parameter(SHADER_GLOW_INTERVAL, glow_interval)
	material.set_shader_parameter(SHADER_GLOW_RADIUS, glow_radius)
	material.set_shader_parameter(SHADER_TRAVEL_TIME, travel_time)


func _get_length() -> float:
	if points.size() < 2:
		return 0.0
	
	var length := 0.0
	for i in range(points.size() - 1):
		length += points[i].distance_to(points[i + 1])
	return length
