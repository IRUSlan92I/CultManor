class_name LockedDoor
extends Door


var _unlocked := false


func _is_key(_node: Node) -> bool:
	return false


func _can_open(body: Node2D) -> bool:
	if _unlocked: return true
	if not body.has_node("Pickups"): return false
	if not body.has_method("remove_pickup"): return false
	
	for pickup in body.get_node("Pickups").get_children():
		if _is_key(pickup):
			body.remove_pickup(pickup)
			_unlocked = true
			return true
	
	return false


func _can_close(_body: Node2D) -> bool:
	return _unlocked
