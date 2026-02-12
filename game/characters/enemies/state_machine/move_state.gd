@abstract
class_name CultistMoveState
extends CultistState


@export var fall_state: CultistState


@warning_ignore("unused_private_class_variable")
var _direction := 0
@warning_ignore("unused_private_class_variable")
var _wall_high_ray_cast : RayCast2D
@warning_ignore("unused_private_class_variable")
var _wall_low_ray_cast : RayCast2D
var _player_ray_cast : RayCast2D


func enter() -> void:
	cultist._set_ray_cast_enable(_player_ray_cast, true)


func exit() -> void:
	cultist._set_ray_cast_enable(_player_ray_cast, false)
