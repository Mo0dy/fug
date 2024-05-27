extends MoveState

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	# do attack
	player.play_animation("Attack")
	player.weapon.attack()
	player.weapon.connect("done", Callable(self, "_on_Weapon_done"))

func leave() -> void:
	super.leave()
	player.weapon.disconnect("done", Callable(self, "_on_Weapon_done"))

func unhandled_input(event : InputEvent) -> void:
	# TODO: check some global dash timeout
	# you can also dash if the attack began in limbo
	var can_dash = player.movement_controller.can_dash || controller.last_state == "Limbo"
	if event.is_action_pressed("dash") && can_dash && player.has_dash:
		controller.change_to("Shove")

func _on_Weapon_done() -> void:
	controller.change_to("Default")
