extends AbstractActivatableObject


signal switching
signal switched


enum State {
	TurnedLeft,
	TurnedRight,
	TurningLeft,
	TurningRight,
}

const ANIMATION_BY_STATE : Dictionary[State, String] = {
	State.TurnedLeft: "turned_left",
	State.TurnedRight: "turned_right",
	State.TurningLeft: "turning_left",
	State.TurningRight: "turning_right",
}


@export var initial_state: State = State.TurnedLeft


var _current_state : State


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	super._ready()
	_current_state = initial_state
	_update_animation()


func _activate() -> void:
	var set_state := func(state: State) -> void:
		_current_state = state
		_update_animation()
		hover_tip.hide()
		switching.emit()
		SoundManager.play_sfx_stream(SoundManager.sfx_stream_lever, global_position)
	
	match _current_state:
		State.TurnedLeft:
			set_state.call(State.TurningRight)
		State.TurnedRight:
			set_state.call(State.TurningLeft)


func _update_animation() -> void:
	var animation := ANIMATION_BY_STATE[_current_state]
	animated_sprite.play(animation)


func _on_animation_finished() -> void:
	var set_state := func(state: State) -> void:
		_current_state = state
		_update_animation()
		switched.emit()
		if _player_in_range:
			hover_tip.show()
	
	match _current_state:
		State.TurningLeft:
			set_state.call(State.TurnedLeft)
		State.TurningRight:
			set_state.call(State.TurnedRight)
