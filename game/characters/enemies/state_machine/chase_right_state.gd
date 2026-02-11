extends CultistChaseState


func init() -> void:
	_direction = DIRECTION_RIGHT
	_wall_ray_cast = cultist.right_wall_ray
	_player_ray_cast = cultist.right_player_distant_ray


func enter() -> void:
	cultist.sprite.play(CultistSprite.ANIMATION_CHASE_RIGHT)


func _is_target_reached() -> bool:
	return cultist.position.x >= cultist.target_x
