@tool
class_name HiddenColorPlatform
extends AbstractColorPlatform


func _ready() -> void:
	super._ready()
	
	icon_sprite.play(ANIMATION_HIDING)
	if not Engine.is_editor_hint():
		if initial_color == CollisionSwitcher.ObjectColor.White:
			platform_sprite.hide()


func set_player(player: Player) -> void:
	player.color_switched.connect(_on_player_color_switched)


func _on_player_color_switched(player_new_color: CollisionSwitcher.ObjectColor) -> void:
	if player_new_color == initial_color:
		platform_sprite.hide()
	else:
		platform_sprite.show()
