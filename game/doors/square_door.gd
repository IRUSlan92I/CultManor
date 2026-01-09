class_name SquareDoor
extends LockedDoor


func _is_key(node: Node) -> bool:
	return node is SquareKeyPickup
