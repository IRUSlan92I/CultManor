extends CultistMoveState


func _ready() -> void:
	_direction = DIRECTION_LEFT
	_wall_ray_cast = cultist.left_wall_ray
	_player_ray_cast = cultist.left_player_distant_ray
