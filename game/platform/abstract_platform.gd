@tool
class_name AbstractPlatform
extends Node2D


const TILE_SIZE = 8
const MIN_WIDTH = TILE_SIZE * 2
const MAX_WIDTH = TILE_SIZE * 32


@export_range(MIN_WIDTH, MAX_WIDTH, TILE_SIZE) var platform_width: int = MIN_WIDTH:
	set(value):
		value = clampi(value, MIN_WIDTH, MAX_WIDTH)
		platform_width = value - (value % TILE_SIZE)
		if is_node_ready():
			rebuild_platform()


@onready var collision: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var platform_sprite: Sprite2D = $PlatformSprite
@onready var icon_sprite: AnimatedSprite2D = $IconSprite


func _ready() -> void:
	platform_sprite.material.set_shader_parameter("tile_size", TILE_SIZE)
	rebuild_platform()


func rebuild_platform() -> void:
	var shape := collision.shape as RectangleShape2D
	if not shape:
		shape = RectangleShape2D.new()
		collision.shape = shape
	shape.size = Vector2(platform_width, TILE_SIZE)
	
	platform_sprite.material.set_shader_parameter("platform_width", platform_width)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
