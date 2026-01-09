class_name BookDoor
extends LockedDoor


func _is_key(node: Node) -> bool:
	return node is BookPickup
