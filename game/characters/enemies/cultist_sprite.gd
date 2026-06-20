@tool
class_name CultistSprite
extends Sprite2D


enum View {
	Front,
	Right,
	Left,
}


const SHADER_SWITCH_COLORS = "shader_parameter/switch_colors"
const SHADER_INTENSITY = "shader_parameter/intensity"
const SHADER_SEED = "shader_parameter/seed"


const is_color_switched : Dictionary[Cultist.Type, bool] = {
	Cultist.Type.White: false,
	Cultist.Type.Black: true,
	Cultist.Type.Gray: false,
}
const intensity : Dictionary[Cultist.Type, float] = {
	Cultist.Type.White: 1.0,
	Cultist.Type.Black: 1.0,
	Cultist.Type.Gray: 0.5,
}

const ANIMATION_FALL = "fall"
const ANIMATION_FALL_LEFT = "fall_left"
const ANIMATION_FALL_RIGHT = "fall_right"
const ANIMATION_JUMP = "jump"
const ANIMATION_JUMP_LEFT = "jump_left"
const ANIMATION_JUMP_RIGHT = "jump_right"
const ANIMATION_IDLE = "idle"
const ANIMATION_LOOK_AROUND = "look_around"
const ANIMATION_LOOK_AROUND_1 = "look_around_1"
const ANIMATION_LOOK_AROUND_2 = "look_around_2"
const ANIMATION_WALK_LEFT = "walk_left"
const ANIMATION_WALK_RIGHT = "walk_right"
const ANIMATION_CHASE_LEFT = "chase_left"
const ANIMATION_CHASE_RIGHT = "chase_right"

const LOOK_AROUND_ANIMATIONS : Array[String] = [
	ANIMATION_LOOK_AROUND_1,
	ANIMATION_LOOK_AROUND_2,
]


@export var type := Cultist.Type.White:
	set(value):
		type = value
		if is_node_ready():
			_update_type()

@export var view := View.Front:
	set(value):
		view = value
		if is_node_ready():
			_update_view()


@onready var animated_sprite : AnimatedSprite2D = $SubViewport/AnimatedSprite2D


func _ready() -> void:
	_update_type()
	_update_view()
	if not Engine.is_editor_hint():
		material.set(SHADER_SEED, randf())


func _update_type() -> void:
	material.set(SHADER_INTENSITY, intensity[type])
	material.set(SHADER_SWITCH_COLORS, is_color_switched[type])


func _update_view() -> void:
	match view:
		View.Front:
			animated_sprite.animation = ANIMATION_IDLE
		View.Left:
			animated_sprite.animation = ANIMATION_WALK_LEFT
		View.Right:
			animated_sprite.animation = ANIMATION_WALK_RIGHT
