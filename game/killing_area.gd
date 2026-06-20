class_name KillingArea
extends Area2D


enum Type {
	None,
	Water,
	Cultist,
}


@export var type := Type.None


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D: return
	
	if body.has_method("kill"):
		body.kill(type)
	else:
		body.queue_free()
