class_name LevelSelection
extends Control


@export var levels : Array[PackedScene] = []


@onready var grid : GridContainer = $%GridContainer


func _ready() -> void:
	levels = levels.filter(func(item: PackedScene) -> bool: return item != null)
	
	for i in range(levels.size()):
		var level := levels[i]
		var next_level := levels[i+1] if i+1 < levels.size() else null
		var disable := SaveManager.completed_levels < i
		
		var button : Button = Button.new()
		button.text = "Level %d" % (i + 1)
		button.disabled = disable
		button.focus_mode = Control.FOCUS_NONE if disable else Control.FOCUS_ALL
		grid.add_child(button)
		button.pressed.connect(_on_level_selected.bind(i, level, next_level))
		
		if i == 0:
			button.grab_focus()


func _on_level_selected(index: int, level: PackedScene, next_level: PackedScene) -> void:
	get_tree().set_meta(AbstractLevel.CURRENT_LEVEL_INDEX, index)
	get_tree().set_meta(AbstractLevel.NEXT_LEVEL_META, next_level)
	get_tree().change_scene_to_packed(level)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/menu/main_menu.tscn")
