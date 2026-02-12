class_name AbstractCultist
extends CharacterBody2D


const MAX_WALK_SPEED = 85
const MAX_CHASE_SPEED = 170
const ACCELERATION = 600.0
const JUMP_VELOCITY = 333.0
const JUMP_GRAVITY_FACTOR = 1.0
const FALL_GRAVITY_FACTOR = 1.5


var target_x := 0.0


@onready var sprite : AnimatedSprite2D = $CultistSprite

@onready var left_wall_ray : RayCast2D = $%LeftWallRay
@onready var right_wall_ray : RayCast2D = $%RightWallRay

@onready var left_player_close_ray : RayCast2D = $%LeftPlayerCloseRay
@onready var right_player_close_ray : RayCast2D = $%RightPlayerCloseRay

@onready var left_player_distant_ray : RayCast2D = $%LeftPlayerDistantRay
@onready var right_player_distant_ray : RayCast2D = $%RightPlayerDistantRay

@onready var state_machine : CultistStateMachine = $CultistStateMachine
@onready var chase_left_state : CultistState = $CultistStateMachine/ChaseLeftState
@onready var chase_right_state : CultistState = $CultistStateMachine/ChaseRightState
@onready var look_around_state : CultistState = $CultistStateMachine/LookAroundState


func _ready() -> void:
	_set_ray_cast_enable(left_player_close_ray, false)
	_set_ray_cast_enable(right_player_close_ray, false)
	_set_ray_cast_enable(left_player_distant_ray, false)
	_set_ray_cast_enable(right_player_distant_ray, false)
	
	state_machine.init()


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	move_and_slide()


func update_x_velocity(direction: int, max_speed: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction * max_speed, ACCELERATION * delta)


func get_gravity_factor() -> float:
	return JUMP_GRAVITY_FACTOR if velocity.y < 0.0 else FALL_GRAVITY_FACTOR


func _set_ray_cast_enable(ray_cast: RayCast2D, enabled: bool) -> void:
	ray_cast.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
