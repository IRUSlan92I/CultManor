extends PlayerState


const LOOK_AROUND_CHANCE = 25


@export var look_around_state: PlayerState


func enter() -> void:
	player.sprite.animation_looped.connect(_on_animation_looped)
	player.sprite.play(PlayerSprite.ANIMATION_IDLE)


func exit() -> void:
	player.sprite.animation_looped.disconnect(_on_animation_looped)


func _on_animation_looped() -> void:
	if randi_range(1, 100) <= LOOK_AROUND_CHANCE:
		switch_state.emit(look_around_state)
