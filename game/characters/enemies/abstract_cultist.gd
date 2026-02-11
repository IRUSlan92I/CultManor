class_name AbstractCultist
extends CharacterBody2D


const MAX_WALK_SPEED = 85
const MAX_CHASE_SPEED = 170
const ACCELERATION = 600.0


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


func _ready() -> void:
	_set_ray_cast_enable(left_player_close_ray, false)
	_set_ray_cast_enable(right_player_close_ray, false)
	_set_ray_cast_enable(left_player_distant_ray, false)
	_set_ray_cast_enable(right_player_distant_ray, false)
	
	state_machine.init()


func _physics_process(delta: float) -> void:
	move_and_slide()
	state_machine.physics_process(delta)


func update_x_velocity(direction: int, max_speed: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction * max_speed, ACCELERATION * delta)


#TODO Rework
func _on_player_touch_area_entered(body: Node2D) -> void:
	if body is Player:
		target_x = body.position.x
		if body.position.x < position.x:
			state_machine._change_state(chase_left_state)
		else:
			state_machine._change_state(chase_right_state)


func _set_ray_cast_enable(ray_cast: RayCast2D, enabled: bool) -> void:
	ray_cast.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
