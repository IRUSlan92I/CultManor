class_name PlayerStateMachine
extends StateMachine


@export var player: Player

@export var dead_state: PlayerState


func _ready() -> void:
	if not player.is_node_ready():
		await player.ready
	
	super._ready()


func kill_player() -> void:
	_change_state(dead_state)
