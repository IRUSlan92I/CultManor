@tool
class_name Cultist
extends CharacterBody2D


enum Type {
	White,
	Black,
	Gray,
}


const MAX_WALK_SPEED = 85
const MAX_CHASE_SPEED = 170
const ACCELERATION = 600.0
const JUMP_VELOCITY = 222.0
const JUMP_GRAVITY_FACTOR = 1.0
const FALL_GRAVITY_FACTOR = 1.5


@export var type := Type.White:
	set(value):
		type = value
		if is_node_ready():
			_updated_sprite()
			_updated_collision()


var target_x := 0.0


@onready var sprite : Sprite2D = $CultistSprite
@onready var animated_sprite : AnimatedSprite2D = $CultistSprite.animated_sprite
@onready var water_splash : GPUParticles2D = $WaterSplash
@onready var killing_area : KillingArea = $KillingArea

@onready var left_wall_high_ray : RayCast2D = $WallCheckHigh/LeftWallRay
@onready var right_wall_high_ray : RayCast2D = $WallCheckHigh/RightWallRay

@onready var left_wall_low_ray : RayCast2D = $WallCheckLow/LeftWallRay
@onready var right_wall_low_ray : RayCast2D = $WallCheckLow/RightWallRay

@onready var left_player_close_ray : RayCast2D = $%LeftPlayerCloseRay
@onready var right_player_close_ray : RayCast2D = $%RightPlayerCloseRay

@onready var left_player_distant_ray : RayCast2D = $%LeftPlayerDistantRay
@onready var right_player_distant_ray : RayCast2D = $%RightPlayerDistantRay

@onready var wall_rays : Array[RayCast2D] = [
	left_wall_high_ray, right_wall_high_ray,
	left_wall_low_ray, right_wall_low_ray,
]
@onready var player_rays : Array[RayCast2D] = [
	left_player_close_ray, right_player_close_ray,
	left_player_distant_ray, right_player_distant_ray,
]

@onready var state_machine : CultistStateMachine = $CultistStateMachine
@onready var chase_left_state : CultistState = $CultistStateMachine/ChaseLeftState
@onready var chase_right_state : CultistState = $CultistStateMachine/ChaseRightState
@onready var look_around_state : CultistState = $CultistStateMachine/LookAroundState


func _ready() -> void:
	_updated_sprite()
	_updated_collision()
	if not Engine.is_editor_hint():
		_set_ray_cast_enable(left_player_close_ray, false)
		_set_ray_cast_enable(right_player_close_ray, false)
		_set_ray_cast_enable(left_player_distant_ray, false)
		_set_ray_cast_enable(right_player_distant_ray, false)
		state_machine.init()


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state_machine.physics_process(delta)
		move_and_slide()


func kill(killing_type := KillingArea.Type.None) -> void:
	match killing_type:
		KillingArea.Type.Water:
			SoundManager.play_sfx_stream(SoundManager.sfx_stream_splash, global_position)
			water_splash.finished.connect(queue_free)
			water_splash.restart()
		_:
			queue_free()


func update_x_velocity(direction: int, max_speed: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction * max_speed, ACCELERATION * delta)


func get_gravity_factor() -> float:
	return JUMP_GRAVITY_FACTOR if velocity.y < 0.0 else FALL_GRAVITY_FACTOR


func _updated_sprite() -> void:
	sprite.type = type


func _updated_collision() -> void:
	const C = CollisionSwitcher.Collisions

	var layer: int
	var world_mask: int
	var player_mask: int

	match type:
		Type.White:
			layer = C.WHITE_ENEMY
			world_mask = C.WHITE_WORLD
			player_mask = C.WHITE_PLAYER
		Type.Black:
			layer = C.BLACK_ENEMY
			world_mask = C.BLACK_WORLD
			player_mask = C.BLACK_PLAYER
		Type.Gray:
			layer = C.GREY_ENEMY
			world_mask = C.WHITE_WORLD | C.BLACK_WORLD
			player_mask = C.WHITE_PLAYER | C.BLACK_PLAYER
		_:
			return
	world_mask |= C.GREY_WORLD
	
	collision_layer = layer
	_set_mask(world_mask, player_mask)


func _set_mask(world_mask: int, player_mask: int) -> void:
	collision_mask = world_mask
	for ray in wall_rays:
		ray.collision_mask = world_mask
	for ray in player_rays:
		ray.collision_mask = world_mask | player_mask
	killing_area.collision_mask = player_mask


func _set_ray_cast_enable(ray_cast: RayCast2D, enabled: bool) -> void:
	ray_cast.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	if Engine.is_editor_hint():
		if enabled: ray_cast.show()
		else: ray_cast.hide()
