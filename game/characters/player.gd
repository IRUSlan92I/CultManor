class_name Player
extends CharacterBody2D


const ANIMATION_IDLE = "idle"
const ANIMATION_LOOK_AROUND_1 = "look_around_1"
const ANIMATION_LOOK_AROUND_2 = "look_around_2"
const ANIMATION_WALK_LEFT = "walk_left"
const ANIMATION_WALK_RIGHT = "walk_right"
const ANIMATION_FALL_DOWN = "fall_down"
const ANIMATION_FALL_DOWN_LEFT = "fall_down_left"
const ANIMATION_FALL_DOWN_RIGHT = "fall_down_right"
const ANIMATION_FALL_UP = "fall_up"
const ANIMATION_FALL_UP_LEFT = "fall_up_left"
const ANIMATION_FALL_UP_RIGHT = "fall_up_right"

const LOOK_AROUND_CHANCE = 25


@export_range(0.0, 1000.0) var max_speed := 160
@export_range(0.0, 1000.0) var acceleration := 600.0
@export_range(0.0, 1000.0) var jump_velocity := 320.0
@export_range(0.0, 10.0) var switch_time := 1.0


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher


func _ready() -> void:
	collision_switcher.material = sprite.material


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
	
	_update_animation()
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_color"):
		collision_switcher.switch_color(switch_time)


func _update_animation() -> void:
	var animation := _get_animation()
	if sprite.animation != animation:
		sprite.play(animation)


func _get_animation() -> String:
	if is_on_floor():
		if velocity.x > 0:
			return ANIMATION_WALK_RIGHT
		elif velocity.x < 0:
			return ANIMATION_WALK_LEFT
	else:
		if is_zero_approx(velocity.x):
			if velocity.y > 0:
				return ANIMATION_FALL_DOWN
			else:
				return ANIMATION_FALL_UP
		if velocity.x > 0:
			if velocity.y > 0:
				return ANIMATION_FALL_DOWN_RIGHT
			else:
				return ANIMATION_FALL_UP_RIGHT
		elif velocity.x < 0:
			if velocity.y > 0:
				return ANIMATION_FALL_DOWN_LEFT
			else:
				return ANIMATION_FALL_UP_LEFT
	
	if sprite.animation in [ANIMATION_LOOK_AROUND_1, ANIMATION_LOOK_AROUND_2]:
		return sprite.animation
	
	return ANIMATION_IDLE


func _on_animation_finished() -> void:
	match sprite.animation:
		ANIMATION_LOOK_AROUND_1, ANIMATION_LOOK_AROUND_2:
			sprite.play(ANIMATION_IDLE)


func _on_animation_looped() -> void:
	match sprite.animation:
		ANIMATION_IDLE:
			if randi_range(1, 100) <= LOOK_AROUND_CHANCE:
				_play_look_around_animation()


func _play_look_around_animation() -> void:
	sprite.play(ANIMATION_LOOK_AROUND_1 if randi_range(1, 2) == 1 else ANIMATION_LOOK_AROUND_2)
