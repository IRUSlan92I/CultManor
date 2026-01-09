class_name TriagleDoor
extends LockedDoor


func _is_key(node: Node) -> bool:
	return node is TriangleKeyPickup
