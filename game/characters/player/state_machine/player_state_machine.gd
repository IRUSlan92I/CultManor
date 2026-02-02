class_name PlayerStateMachine
extends StateMachine


@export var player: Player


func _ready() -> void:
	if not player.is_node_ready():
		await player.ready
	
	super._ready()
