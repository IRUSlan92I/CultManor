class_name AbstractEnemy
extends CharacterBody2D


const ANIMATION_FALL_DOWN = "fall_down"
const ANIMATION_FALL_DOWN_LEFT = "fall_down_left"
const ANIMATION_FALL_DOWN_RIGHT = "fall_down_right"
const ANIMATION_FALL_UP = "fall_up"
const ANIMATION_FALL_UP_LEFT = "fall_up_left"
const ANIMATION_FALL_UP_RIGHT = "fall_up_right"
const ANIMATION_IDLE_FRONT = "idle_front"
const ANIMATION_IDLE_REAR = "idle_rear"
const ANIMATION_LOOK_AROUND_FRONT_1 = "look_around_front_1"
const ANIMATION_LOOK_AROUND_FRONT_2 = "look_around_front_2"
const ANIMATION_LOOK_AROUND_REAR_1 = "look_around_rear_1"
const ANIMATION_LOOK_AROUND_REAR_2 = "look_around_rear_2"
const ANIMATION_WALK_LEFT = "walk_left"
const ANIMATION_WALK_RIGHT = "walk_right"

const LOOK_AROUND_FRONT_ANIMATIONS = [
	ANIMATION_LOOK_AROUND_FRONT_1,
	ANIMATION_LOOK_AROUND_FRONT_2,
]
const LOOK_AROUND_REAR_ANIMATIONS = [
	ANIMATION_LOOK_AROUND_REAR_1,
	ANIMATION_LOOK_AROUND_REAR_2,
]

const MAX_SPEED = 165
const ACCELERATION = 600.0
const LOOK_AROUND_CHANCE = 25


enum Type {
	Front,
	Rear,
}


enum State {
	Idle,
	LookAround,
	Chasing,
}


@export var type : Type = Type.Front
@export var state : State = State.Idle


var _target_x := 0.0


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state == State.Chasing:
		if is_equal_approx(position.x, _target_x):
			state = State.LookAround
		else:
			var direction := signf(_target_x - position.x)
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	
	_update_animation()
	
	move_and_slide()


func _update_animation() -> void:
	if is_zero_approx(velocity.y):
		match state:
			State.Idle:
				_play_idle_animation()
			State.LookAround:
				_play_look_around_animation()
			State.Chasing:
				_play_chasing_animation_animation()
	else:
		_play_fall_animation()


func _play_idle_animation() -> void:
	match type:
		Type.Front:
			_play_animation(ANIMATION_IDLE_FRONT)
		Type.Rear:
			_play_animation(ANIMATION_IDLE_REAR)


func _play_look_around_animation() -> void:
	if _is_current_animation_look_around: return
	
	match type:
		Type.Front:
			var animation := _get_random_animation(LOOK_AROUND_FRONT_ANIMATIONS)
			_play_animation(animation)
		Type.Rear:
			var animation := _get_random_animation(LOOK_AROUND_REAR_ANIMATIONS)
			_play_animation(animation)


func _play_chasing_animation_animation() -> void:
	if is_zero_approx(velocity.x):
		pass
	elif velocity.x < 0:
		_play_animation(ANIMATION_WALK_LEFT)
	else:
		_play_animation(ANIMATION_WALK_RIGHT)


func _play_fall_animation() -> void:
	if is_zero_approx(velocity.x):
		var animation := ANIMATION_FALL_UP if velocity.y < 0 else ANIMATION_FALL_DOWN
		_play_animation(animation)
	elif velocity.x < 0:
		var animation := ANIMATION_FALL_UP_LEFT if velocity.y < 0 else ANIMATION_FALL_DOWN_LEFT
		_play_animation(animation)
	else:
		var animation := ANIMATION_FALL_UP_RIGHT if velocity.y < 0 else ANIMATION_FALL_DOWN_RIGHT
		_play_animation(animation)


func _is_current_animation_look_around() -> bool:
	if not sprite.is_playing(): return false
	if sprite.animation in LOOK_AROUND_FRONT_ANIMATIONS: return true
	if sprite.animation in LOOK_AROUND_REAR_ANIMATIONS: return true
	return false


func _get_random_animation(animations: Array[String]) -> String:
	var index := randi_range(0, animations.size() - 1)
	return animations[index]


func _play_animation(animation: String) -> void:
	if not sprite.is_playing() or sprite.animation != animation:
		sprite.play(animation)


func _on_animation_finished() -> void:
	state = State.Idle


func _on_animation_looped() -> void:
	if state == State.Idle and randi_range(1, 100) <= LOOK_AROUND_CHANCE:
		state = State.LookAround
