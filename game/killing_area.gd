class_name KillingArea
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D: return
	
	if body.has_method("kill"):
		body.kill()
	else:
		body.queue_free()
