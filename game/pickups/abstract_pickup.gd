class_name AbstractPickup
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_pickup"):
		collision_mask = 0
		body.add_pickup(self)
