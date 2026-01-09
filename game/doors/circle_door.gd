class_name CircleDoor
extends LockedDoor


func _is_key(node: Node) -> bool:
	return node is CircleKeyPickup
