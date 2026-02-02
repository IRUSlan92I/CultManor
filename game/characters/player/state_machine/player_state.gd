class_name PlayerState
extends AbstractState


@export var player: Player


@export var idle_state: PlayerState
@export var walk_left_state: PlayerState
@export var walk_right_state: PlayerState
@export var dead_state: PlayerState
@export var jump_state: PlayerState
@export var jump_left_state: PlayerState
@export var jump_right_state: PlayerState
@export var fall_state: PlayerState
@export var fall_left_state: PlayerState
@export var fall_right_state: PlayerState


func physics_process(_delta: float) -> void:
	if player.is_dead:
		switch_state.emit(dead_state)
	elif player.velocity.is_zero_approx():
		switch_state.emit(idle_state)
	elif is_zero_approx(player.velocity.y):
		if player.velocity.x < 0:
			switch_state.emit(walk_left_state)
		else:
			switch_state.emit(walk_right_state)
	else:
		if player.velocity.y < 0:
			if is_zero_approx(player.velocity.x):
				switch_state.emit(jump_state)
			elif player.velocity.x < 0:
				switch_state.emit(jump_left_state)
			else:
				switch_state.emit(jump_right_state)
		else:
			if is_zero_approx(player.velocity.x):
				switch_state.emit(fall_state)
			elif player.velocity.x < 0:
				switch_state.emit(fall_left_state)
			else:
				switch_state.emit(fall_right_state)
		
