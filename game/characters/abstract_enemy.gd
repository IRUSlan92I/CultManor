class_name AbstractEnemy
extends CharacterBody2D


enum Type {
	Standing,
	Walking,
	Random,
}

enum Facing {
	Front,
	Rear,
}

enum State {
	Idle,
	WalkLeft,
	WalkRight,
	LookAround,
	ChasingLeft,
	ChasingRight,
}


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
const ANIMATION_CHASE_LEFT = "chase_left"
const ANIMATION_CHASE_RIGHT = "chase_right"

const LOOK_AROUND_FRONT_ANIMATIONS : Array[String] = [
	ANIMATION_LOOK_AROUND_FRONT_1,
	ANIMATION_LOOK_AROUND_FRONT_2,
]
const LOOK_AROUND_REAR_ANIMATIONS : Array[String] = [
	ANIMATION_LOOK_AROUND_REAR_1,
	ANIMATION_LOOK_AROUND_REAR_2,
]

const MAX_WALK_SPEED = 85
const MAX_CHASE_SPEED = 170
const ACCELERATION = 600.0
const LOOK_AROUND_CHANCE = 25
const WALK_CHANCE = 25

const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1


@export var type : Type = Type.Standing
@export var facing : Facing = Facing.Front
@export var initial_state : State = State.Idle


var _target_x := 0.0
var _target_found := false


@onready var _state : State = initial_state:
	set = _set_state

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var left_wall_ray : RayCast2D = $%LeftWallRay
@onready var right_wall_ray : RayCast2D = $%RightWallRay

@onready var left_player_close_ray : RayCast2D = $%LeftPlayerCloseRay
@onready var right_player_close_ray : RayCast2D = $%RightPlayerCloseRay

@onready var left_player_distant_ray : RayCast2D = $%LeftPlayerDistantRay
@onready var right_player_distant_ray : RayCast2D = $%RightPlayerDistantRay


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match _state:
		State.ChasingLeft:
			_process_player_ray(left_player_distant_ray)
			if position.x < _target_x:
				_state = State.LookAround
			else:
				_update_x_velocity(DIRECTION_LEFT, MAX_CHASE_SPEED, delta)
				_check_wall_collision_and_switch_state(DIRECTION_LEFT)
		State.ChasingRight:
			_process_player_ray(right_player_distant_ray)
			if position.x > _target_x:
				_state = State.LookAround
			else:
				_update_x_velocity(DIRECTION_RIGHT, MAX_CHASE_SPEED, delta)
				_check_wall_collision_and_switch_state(DIRECTION_RIGHT)
		State.WalkLeft:
			if _process_player_ray(left_player_distant_ray):
				_set_chase_state()
			_update_x_velocity(DIRECTION_LEFT, MAX_WALK_SPEED, delta)
			_check_wall_collision_and_switch_state(DIRECTION_LEFT)
		State.WalkRight:
			if _process_player_ray(right_player_distant_ray):
				_set_chase_state()
			_update_x_velocity(DIRECTION_RIGHT, MAX_WALK_SPEED, delta)
			_check_wall_collision_and_switch_state(DIRECTION_RIGHT)
		State.LookAround:
			if not _target_found:
				var close_rays : Array[RayCast2D] = [left_player_close_ray, right_player_close_ray]
				_target_found = _process_player_rays(close_rays)
	
	_update_animation()
	
	move_and_slide()


func _set_state(value: State) -> void:
	_state = value
	
	left_player_close_ray.process_mode = Node.PROCESS_MODE_DISABLED
	right_player_close_ray.process_mode = Node.PROCESS_MODE_DISABLED
	left_player_distant_ray.process_mode = Node.PROCESS_MODE_DISABLED
	right_player_distant_ray.process_mode = Node.PROCESS_MODE_DISABLED
	
	match _state:
		State.ChasingLeft, State.WalkLeft:
			left_player_distant_ray.process_mode = Node.PROCESS_MODE_INHERIT
		State.ChasingRight, State.WalkRight:
			left_player_distant_ray.process_mode = Node.PROCESS_MODE_INHERIT
		State.LookAround:
			left_player_close_ray.process_mode = Node.PROCESS_MODE_INHERIT
			right_player_distant_ray.process_mode = Node.PROCESS_MODE_INHERIT


func _process_player_ray(ray: RayCast2D) -> bool:
	if ray.is_colliding():
		var collider := ray.get_collider()
		if collider is Player:
			_target_x = collider.position.x
			return true
	return false


func _process_player_rays(rays: Array[RayCast2D]) -> bool:
	for ray in rays:
		if _process_player_ray(ray):
			return true
	return false


func _update_x_velocity(direction: int, max_speed: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction * max_speed, ACCELERATION * delta)


func _check_wall_collision_and_switch_state(direction: int) -> void:
	var this_wall_ray := _get_wall_ray(direction)
	var other_wall_ray := _get_wall_ray(-direction)
	
	if this_wall_ray.is_colliding():
		if other_wall_ray.is_colliding():
			_state = State.LookAround
		else:
			match _state:
				State.WalkLeft:
					_state = State.WalkRight
				State.WalkRight:
					_state = State.WalkLeft
				State.ChasingLeft, State.ChasingRight:
					_state = State.LookAround


func _get_wall_ray(direction: int) -> RayCast2D:
	if direction < 0:
		return left_wall_ray
	else:
		return right_wall_ray


func _update_animation() -> void:
	if is_zero_approx(velocity.y):
		match _state:
			State.WalkLeft:
				_play_animation(ANIMATION_WALK_LEFT)
			State.WalkRight:
				_play_animation(ANIMATION_WALK_RIGHT)
			State.ChasingLeft:
				_play_animation(ANIMATION_CHASE_LEFT)
			State.ChasingRight:
				_play_animation(ANIMATION_CHASE_RIGHT)
			State.Idle:
				_play_idle_animation()
			State.LookAround:
				_play_look_around_animation()
	else:
		_play_fall_animation()


func _play_idle_animation() -> void:
	match facing:
		Facing.Front:
			_play_animation(ANIMATION_IDLE_FRONT)
		Facing.Rear:
			_play_animation(ANIMATION_IDLE_REAR)


func _play_look_around_animation() -> void:
	if _is_current_animation_look_around(): return
	
	match facing:
		Facing.Front:
			var animation := _get_random_animation(LOOK_AROUND_FRONT_ANIMATIONS)
			_play_animation(animation)
		Facing.Rear:
			var animation := _get_random_animation(LOOK_AROUND_REAR_ANIMATIONS)
			_play_animation(animation)


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


func _set_walking_state() -> void:
	var is_left_colliding := left_wall_ray.is_colliding()
	var is_right_colliding := right_wall_ray.is_colliding()
	
	if is_left_colliding and is_right_colliding:
		_state = State.Idle
	elif not is_left_colliding and not is_right_colliding:
		_state = State.WalkLeft if randi_range(1, 2) == 1 else State.WalkRight
	elif not is_left_colliding:
		_state = State.WalkLeft
	else:
		_state = State.WalkRight


func _set_chase_state() -> void:
	if _target_x < position.x:
		_state = State.ChasingLeft
	else:
		_state = State.ChasingRight


func _is_walking_state() -> bool:
	return _state == State.WalkLeft or _state == State.WalkRight


func _on_animation_finished() -> void:
	if _target_found:
		_set_chase_state()
		_target_found = false
		return
	
	match type:
		Type.Standing:
			_state = State.Idle
		Type.Walking:
			_set_walking_state()
		Type.Random:
			if randi_range(1, 100) <= WALK_CHANCE:
				_set_walking_state()
			else:
				_state = State.Idle


func _on_animation_looped() -> void:
	if _state == State.Idle or (type == Type.Random and _is_walking_state()):
		if randi_range(1, 100) <= LOOK_AROUND_CHANCE:
			_state = State.LookAround


func _on_player_touch_area_entered(body: Node2D) -> void:
	if body is Player:
		_target_x = body.position.x
		_set_chase_state()
