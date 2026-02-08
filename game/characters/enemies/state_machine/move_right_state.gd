extends CultistMoveState


func _ready() -> void:
	_direction = DIRECTION_RIGHT
	_wall_ray_cast = cultist.right_wall_ray
	_player_ray_cast = cultist.right_player_distant_ray
