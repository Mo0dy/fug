extends PlayerState

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	player.play_animation("Death")
	player.movement_controller.movement_target = Vector2.ZERO
	player.animator.z_index = -15
