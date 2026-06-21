@tool
class_name TouchColorPlatform
extends AbstractColorPlatform


const INTENSITY = 0.85
const INTENSITY_SET_TIME = 0.5


const SWITCH_TIME = 1.5


var _is_body_in := false

var _intensity_tween : Tween


@onready var touch_check_collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var switch_timer: Timer = $SwitchTimer


func _ready() -> void:
	super._ready()
	icon_sprite.hide()
	_reset_intensity()


func rebuild_platform() -> void:
	super.rebuild_platform()
	touch_check_collision.shape.size.x = platform_width - 4


func _switch() -> void:
	collision_switcher.switch_color(SWITCH_TIME)


func _reset_intensity() -> void:
	if _intensity_tween != null and _intensity_tween.is_running():
		_intensity_tween.kill()
	_intensity_tween = create_tween()
	_intensity_tween.tween_property(platform_sprite.material, CollisionSwitcher.SHADER_INTENSITY, \
		INTENSITY, INTENSITY_SET_TIME)


func _on_body_entered(_body: Node2D) -> void:
	_is_body_in = true
	_switch()


func _on_body_exited(_body: Node2D) -> void:
	_is_body_in = false


func _on_collision_switched(_color: CollisionSwitcher.ObjectColor) -> void:
	_reset_intensity()
	if _is_body_in:
		switch_timer.start()


func _on_switch_timer_timeout() -> void:
	if _is_body_in:
		_switch()
