class_name SquareDoor
extends ClosedDoor


func _is_key(node: Node) -> bool:
	return node is SquareKeyPickup
