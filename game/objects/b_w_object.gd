class_name BWObject
extends Node2D


@export var is_colored := true
@export var is_white := true


func invert() -> void:
	is_white = not is_white
