@tool
class_name TouchColorPlatform
extends AbstractColorPlatform


const SWITCH_TIME = 1.5


var _is_body_in := false


@onready var touch_check_collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var switch_timer: Timer = $SwitchTimer


func rebuild_platform() -> void:
	super.rebuild_platform()
	touch_check_collision.shape.size.x = platform_width - 4


func _switch() -> void:
	collision_switcher.switch_color(SWITCH_TIME)


func _on_body_entered(_body: Node2D) -> void:
	_is_body_in = true
	_switch()


func _on_body_exited(_body: Node2D) -> void:
	_is_body_in = false


func _on_collision_switched() -> void:
	if _is_body_in:
		switch_timer.start()


func _on_switch_timer_timeout() -> void:
	if _is_body_in:
		_switch()
