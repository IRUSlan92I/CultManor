class_name BookDoor
extends ClosedDoor


func _is_key(node: Node) -> bool:
	return node is BookPickup
