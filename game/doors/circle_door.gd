class_name CircleDoor
extends ClosedDoor


func _is_key(node: Node) -> bool:
	return node is CircleKeyPickup
