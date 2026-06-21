@tool
class_name AbstractPlatform
extends AnimatableBody2D


const SHADER_SEED = "shader_parameter/seed"
const SHADER_TILE_SIZE = "shader_parameter/tile_size"
const SHADER_PLATFORM_WIDTH = "shader_parameter/platform_width"

const ANIMATION_COLOR_SWITCHING = "color_switching"
const ANIMATION_HIDING = "hiding"

const ANIMATION_SELF_MOVING = "self_moving"

const ANIMATION_MOVING_PREFIX = "moving_"
const ANIMATION_MOVING_UP = "up"
const ANIMATION_MOVING_DOWN = "down"
const ANIMATION_MOVING_LEFT = "left"
const ANIMATION_MOVING_RIGHT = "right"
const ANIMATION_ACTIVE_SUFFIX = "_active"
const ANIMATION_STATIC_SUFFIX = "_static"


const TILE_SIZE = 8
const MIN_WIDTH = TILE_SIZE * 2
const MAX_WIDTH = TILE_SIZE * 32


@export_range(MIN_WIDTH, MAX_WIDTH, TILE_SIZE) var platform_width: int = MIN_WIDTH:
	set(value):
		value = clampi(value, MIN_WIDTH, MAX_WIDTH)
		platform_width = value - (value % TILE_SIZE)
		if is_node_ready():
			rebuild_platform()


@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sub_viewport: SubViewport = $SubViewport
@onready var platform_sprite: Sprite2D = $Sprite2D
@onready var platform_rect: ColorRect = $SubViewport/PlatformRect
@onready var icon_sprite: AnimatedSprite2D = $SubViewport/IconSprite


func _ready() -> void:
	if not Engine.is_editor_hint():
		platform_rect.material.set(SHADER_SEED, randf())
	platform_rect.material.set(SHADER_TILE_SIZE, TILE_SIZE)
	rebuild_platform()


func rebuild_platform() -> void:
	collision.shape.size.x = platform_width
	
	var platfor_size := Vector2(platform_width, TILE_SIZE)
	
	sub_viewport.size = platfor_size
	icon_sprite.position = platfor_size/2
	platform_rect.size.x = platform_width
	platform_rect.position = Vector2.ZERO
	
	platform_rect.material.set(SHADER_PLATFORM_WIDTH, platform_width)
