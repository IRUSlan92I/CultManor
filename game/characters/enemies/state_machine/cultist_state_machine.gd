class_name CultistStateMachine
extends StateMachine


@export var cultist: AbstractCultist


func _ready() -> void:
	if not cultist.is_node_ready():
		await cultist.ready
	
	super._ready()
	
