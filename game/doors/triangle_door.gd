class_name TriagleDoor
extends ClosedDoor


func _is_key(node: Node) -> bool:
	return node is TriangleKeyPickup
