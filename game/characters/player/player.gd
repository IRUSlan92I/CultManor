class_name Player
extends CharacterBody2D


signal dead


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
const ANIMATION_DEATH = "death"

const LOOK_AROUND_CHANCE = 25
const PICKUP_OFFSET = 16.0


@export_range(0.0, 1000.0) var max_speed := 160
@export_range(0.0, 1000.0) var max_fall_speed := 640
@export_range(0.0, 1000.0) var acceleration := 600.0
@export_range(0.0, 1000.0) var jump_velocity := 320.0
@export_range(0.0, 2.0) var jump_gravity_factor := 1.0
@export_range(0.0, 2.0) var fall_gravity_factor := 1.5
@export_range(0.0, 1.0) var passive_jump_factor := 0.5


var _is_alive := true
var _is_switching_needed := false


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher
@onready var pickups : Node2D = $Pickups
@onready var jump_buffer_timer : Timer = $JumpBufferTimer
@onready var coyote_time_timer : Timer = $CoyoteTimeTimer
@onready var center_area : Area2D = $CenterArea2D


func _ready() -> void:
	collision_switcher.material = sprite.material


func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_time_timer.start()
	if is_on_ceiling_only() and velocity.y < 0.0:
		velocity.y = 0.0
	
	if not is_on_floor():
		var gravity_factor := jump_gravity_factor if velocity.y < 0.0 else fall_gravity_factor
		
		if velocity.y < 0.0 and not Input.is_action_pressed("jump"):
			velocity.y *= passive_jump_factor
		
		velocity += get_gravity() * gravity_factor * delta
		velocity.y = clampf(velocity.y, -max_fall_speed, max_fall_speed)
	
	if not _is_alive:
		_slow_down(delta)
	else:
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer.start()
		
		if not coyote_time_timer.is_stopped() and not jump_buffer_timer.is_stopped():
			SoundManager.play_sfx_stream(SoundManager.sfx_stream_jump, global_position)
			velocity.y = -jump_velocity
			jump_buffer_timer.stop()
		
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
		else:
			_slow_down(delta)
		
		_update_animation()
	
	if _is_switching_needed:
		_switch()
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_color"):
		_switch()


func _switch() -> void:
	_is_switching_needed = false
		
	if not _is_alive:
		return
	
	if center_area.get_overlapping_bodies().size() == 0:
		SoundManager.play_sfx_stream(SoundManager.sfx_stream_switch, global_position)
		collision_switcher.switch_color()
	else:
		_is_switching_needed = true


func kill() -> void:
	if not _is_alive: return
	
	SoundManager.play_sfx_stream(SoundManager.sfx_stream_death, global_position)
	_is_alive = false
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	sprite.play(ANIMATION_DEATH)


func add_pickup(pickup: AbstractPickup) -> void:
	pickup.reparent.call_deferred(pickups)
	_rearrange_pickups.call_deferred()


func remove_pickup(pickup: AbstractPickup) -> void:
	if pickup in pickups.get_children():
		pickups.remove_child(pickup)
		pickup.queue_free()
		_rearrange_pickups()


func _slow_down(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, acceleration * delta)


func _is_killing_collider(collider: Object) -> bool:
	if not collider is Node: return false
	
	var node := collider as Node
	return node.has_node("PlayerKiller")


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


func _rearrange_pickups() -> void:
	var children := pickups.get_children()
	var pickup_shift := (children.size() - 1) * PICKUP_OFFSET / 2.0
	
	for i in range(children.size()):
		if not children[i] is Node2D: continue
		var node := children[i] as Node2D
		node.position.x = i * PICKUP_OFFSET - pickup_shift
		node.position.y = 0


func _play_look_around_animation() -> void:
	sprite.play(ANIMATION_LOOK_AROUND_1 if randi_range(1, 2) == 1 else ANIMATION_LOOK_AROUND_2)


func _on_animation_finished() -> void:
	match sprite.animation:
		ANIMATION_LOOK_AROUND_1, ANIMATION_LOOK_AROUND_2:
			sprite.play(ANIMATION_IDLE)
		ANIMATION_DEATH:
			dead.emit()
			queue_free()


func _on_animation_looped() -> void:
	match sprite.animation:
		ANIMATION_IDLE:
			if randi_range(1, 100) <= LOOK_AROUND_CHANCE:
				_play_look_around_animation()
