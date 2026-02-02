class_name StateMachine
extends Node


@export var initial_state: AbstractState


var current_state : AbstractState


func _ready() -> void:
	_connect_states()
	if initial_state:
		_change_state(initial_state)


func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)


func _change_state(new_state: AbstractState) -> void:
	if new_state == null: return
	if new_state == current_state: return
	
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()


func _connect_states() -> void:
	for child in get_children():
		if not child is AbstractState: continue
		var state := child as AbstractState
		state.switch_state.connect(_change_state)
	
