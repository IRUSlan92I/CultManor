class_name AbstractCultist
extends CharacterBody2D


enum Type {
	Standing,
	Walking,
	Random,
}

enum State {
	Idle,
	WalkLeft,
	WalkRight,
	LookAround,
	ChasingLeft,
	ChasingRight,
}


const MAX_WALK_SPEED = 85
const MAX_CHASE_SPEED = 170
const ACCELERATION = 600.0
const LOOK_AROUND_CHANCE = 25
const WALK_CHANCE = 25

const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1


@export var type : Type = Type.Standing
@export var initial_state : State = State.Idle


var target_x := 0.0
var _target_found := false


var _state : State:
	set = _set_state

@onready var sprite : AnimatedSprite2D = $CultistSprite

@onready var left_wall_ray : RayCast2D = $%LeftWallRay
@onready var right_wall_ray : RayCast2D = $%RightWallRay

@onready var left_player_close_ray : RayCast2D = $%LeftPlayerCloseRay
@onready var right_player_close_ray : RayCast2D = $%RightPlayerCloseRay

@onready var left_player_distant_ray : RayCast2D = $%LeftPlayerDistantRay
@onready var right_player_distant_ray : RayCast2D = $%RightPlayerDistantRay


func _ready() -> void:
	_state = initial_state


func _physics_process(delta: float) -> void:
	match _state:
		State.ChasingLeft:
			_process_player_ray(left_player_distant_ray)
			if position.x < target_x:
				SoundManager.play_sfx_stream(SoundManager.sfx_stream_player_lost, global_position)
				_state = State.LookAround
			else:
				update_x_velocity(DIRECTION_LEFT, MAX_CHASE_SPEED, delta)
				_check_wall_collision_and_switch_state(DIRECTION_LEFT)
			_update_animation()
			move_and_slide()
		State.ChasingRight:
			_process_player_ray(right_player_distant_ray)
			if position.x > target_x:
				SoundManager.play_sfx_stream(SoundManager.sfx_stream_player_lost, global_position)
				_state = State.LookAround
			else:
				update_x_velocity(DIRECTION_RIGHT, MAX_CHASE_SPEED, delta)
				_check_wall_collision_and_switch_state(DIRECTION_RIGHT)
			_update_animation()
			move_and_slide()
		State.WalkLeft:
			if _process_player_ray(left_player_distant_ray):
				_set_chase_state()
			update_x_velocity(DIRECTION_LEFT, MAX_WALK_SPEED, delta)
			_check_wall_collision_and_switch_state(DIRECTION_LEFT)
			_update_animation()
			move_and_slide()
		State.WalkRight:
			if _process_player_ray(right_player_distant_ray):
				_set_chase_state()
			update_x_velocity(DIRECTION_RIGHT, MAX_WALK_SPEED, delta)
			_check_wall_collision_and_switch_state(DIRECTION_RIGHT)
			_update_animation()
			move_and_slide()
		State.LookAround:
			update_x_velocity(0, MAX_WALK_SPEED * 2, delta)
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
	left_player_close_ray.hide()
	right_player_close_ray.hide()
	left_player_distant_ray.hide()
	right_player_distant_ray.hide()
	
	match _state:
		State.ChasingLeft, State.WalkLeft:
			left_player_distant_ray.process_mode = Node.PROCESS_MODE_INHERIT
			left_player_distant_ray.show()
		State.ChasingRight, State.WalkRight:
			right_player_distant_ray.process_mode = Node.PROCESS_MODE_INHERIT
			right_player_distant_ray.show()
		State.LookAround:
			left_player_close_ray.process_mode = Node.PROCESS_MODE_INHERIT
			right_player_close_ray.process_mode = Node.PROCESS_MODE_INHERIT
			left_player_close_ray.show()
			right_player_close_ray.show()


func _process_player_ray(ray: RayCast2D) -> bool:
	if ray.is_colliding():
		ray.force_raycast_update()
		var collider := ray.get_collider()
		if collider is Player:
			target_x = collider.position.x
			return true
	return false


func _process_player_rays(rays: Array[RayCast2D]) -> bool:
	for ray in rays:
		if _process_player_ray(ray):
			return true
	return false


func update_x_velocity(direction: int, max_speed: float, delta: float) -> void:
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
					var stream := SoundManager.sfx_stream_player_lost
					SoundManager.play_sfx_stream(stream, global_position)
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
				_play_animation(CultistSprite.ANIMATION_WALK_LEFT)
			State.WalkRight:
				_play_animation(CultistSprite.ANIMATION_WALK_RIGHT)
			State.ChasingLeft:
				_play_animation(CultistSprite.ANIMATION_CHASE_LEFT)
			State.ChasingRight:
				_play_animation(CultistSprite.ANIMATION_CHASE_RIGHT)
			State.Idle:
				_play_idle_animation()
			State.LookAround:
				_play_look_around_animation()


func _play_idle_animation() -> void:
	_play_animation(CultistSprite.ANIMATION_IDLE)


func _play_look_around_animation() -> void:
	if _is_current_animation_look_around(): return
	_play_animation(CultistSprite.LOOK_AROUND_ANIMATIONS.pick_random())


func _is_current_animation_look_around() -> bool:
	if not sprite.is_playing(): return false
	if sprite.animation in CultistSprite.LOOK_AROUND_ANIMATIONS: return true
	return false


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
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_player_spoted, global_position)
	if target_x < position.x:
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
		target_x = body.position.x
		_set_chase_state()
