class_name StateMachine
extends Node


var current_state : AbstractState


func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)


func change_state(new_state: AbstractState) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
