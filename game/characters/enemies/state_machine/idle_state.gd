extends CultistState


@export var fall_state: CultistState


func enter() -> void:
	cultist.sprite.play(CultistSprite.ANIMATION_IDLE)


func physics_process(_delta: float) -> void:
	if not cultist.is_on_floor():
		switch_state.emit(fall_state)
