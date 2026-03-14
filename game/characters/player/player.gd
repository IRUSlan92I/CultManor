class_name Player
extends CharacterBody2D


signal dead


const PICKUP_OFFSET = 16.0


@export_range(0.0, 1000.0) var max_speed := 160
@export_range(0.0, 1000.0) var max_fall_speed := 640
@export_range(0.0, 1000.0) var acceleration := 600.0
@export_range(0.0, 1000.0) var jump_velocity := 333.0
@export_range(0.0, 2.0) var jump_gravity_factor := 1.0
@export_range(0.0, 2.0) var fall_gravity_factor := 1.5
@export_range(0.0, 1.0) var passive_jump_factor := 0.5


var is_dead := false
var _is_switching_needed := false


@onready var camera : Camera2D = $Camera2D
@onready var sprite : AnimatedSprite2D = $PlayerSprite
@onready var collision_switcher : CollisionSwitcher = $CollisionSwitcher
@onready var pickups : Node2D = $Pickups
@onready var jump_buffer_timer : Timer = $JumpBufferTimer
@onready var coyote_time_timer : Timer = $CoyoteTimeTimer
@onready var center_area : Area2D = $CenterArea2D
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine


func _ready() -> void:
	collision_switcher.material = sprite.material
	
	state_machine.init()


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
	
	if is_dead:
		_slow_down(delta*3)
	else:
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer.start()
		
		if not coyote_time_timer.is_stopped() and not jump_buffer_timer.is_stopped():
			SoundManager.play_sfx_stream(SoundManager.sfx_stream_jump, global_position)
			velocity.y = -jump_velocity
			jump_buffer_timer.stop()
			coyote_time_timer.stop()
		
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
		else:
			_slow_down(delta)
	
	if _is_switching_needed:
		_switch()
	
	move_and_slide()
	state_machine.physics_process(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_color"):
		_switch()


func _switch() -> void:
	_is_switching_needed = false
		
	if is_dead:
		return
	
	if center_area.get_overlapping_bodies().size() == 0:
		SoundManager.play_sfx_stream(SoundManager.sfx_stream_switch, global_position)
		collision_switcher.switch_color()
	else:
		_is_switching_needed = true


func kill() -> void:
	is_dead = true


func process_dead() -> void:
	dead.emit()
	queue_free()


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


func _rearrange_pickups() -> void:
	var children := pickups.get_children()
	var pickup_shift := (children.size() - 1) * PICKUP_OFFSET / 2.0
	
	for i in range(children.size()):
		if not children[i] is Node2D: continue
		var node := children[i] as Node2D
		node.position.x = i * PICKUP_OFFSET - pickup_shift
		node.position.y = 0
