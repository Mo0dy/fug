extends MoveState

class_name PlayerDefault

func process(delta : float) -> void:
	super.process(delta)
	if player.movement_controller.get_velocity() > 5:
		player.play_animation("Walking")
	else:
		player.play_animation("Idle")

func unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("attack"):
		controller.change_to("Melee")
	elif event.is_action_pressed("dash") && player.movement_controller.can_dash && player.has_dash:
		controller.change_to("Dash")
	elif event.is_action_pressed("alt_attack") && player.has_hook:
		controller.change_to("Grab")
