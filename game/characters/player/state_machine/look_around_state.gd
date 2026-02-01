extends PlayerState


const ANIMATION_LOOK_AROUND_1 = "look_around_1"
const ANIMATION_LOOK_AROUND_2 = "look_around_2"


@export var idle_state: PlayerState


func enter() -> void:
	player.sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	player.sprite.play(_get_animation())


func _on_animation_finished() -> void:
	switch_state.emit(idle_state)


func _get_animation() -> String:
	return ANIMATION_LOOK_AROUND_1 if randi_range(1, 2) == 1 else ANIMATION_LOOK_AROUND_2
