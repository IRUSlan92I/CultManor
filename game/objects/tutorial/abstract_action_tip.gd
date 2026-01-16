class_name AbstractActionTip
extends Node2D


@onready var sprite_keyboard : Sprite2D = $SpriteKbd
@onready var sprite_gamepad : Sprite2D = $SpritePad


func _ready() -> void:
	_updated_by_input_type(InputManager.get_type())
	InputManager.type_changed.connect(_updated_by_input_type)


func _updated_by_input_type(type: InputManager.Type) -> void:
	match type:
		InputManager.Type.Keyboard:
			sprite_keyboard.show()
			sprite_gamepad.hide()
		InputManager.Type.Gamepad:
			sprite_keyboard.hide()
			sprite_gamepad.show()
