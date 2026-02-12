extends CultistChaseState


func init() -> void:
	_direction = DIRECTION_LEFT
	_wall_high_ray_cast = cultist.left_wall_high_ray
	_wall_low_ray_cast = cultist.left_wall_low_ray
	_player_ray_cast = cultist.left_player_distant_ray


func enter() -> void:
	cultist.sprite.play(CultistSprite.ANIMATION_CHASE_LEFT)


func _is_target_reached() -> bool:
	return cultist.position.x <= cultist.target_x
