extends PlayerDefault

@export var shove_strength : float = 350

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	player.grappling_hook.connect("drop_body", Callable(self, "_on_GrapplingHook_drop_body"))
	# HACK: No idea why I need this:
	if not player.grappling_hook.has_actor:
		controller.change_to("Default")

func leave() -> void:
	super.leave()
	player.grappling_hook.disconnect("drop_body", Callable(self, "_on_GrapplingHook_drop_body"))

func unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("attack"):
		var grappled_actor := player.grappling_hook.grappled_actor
		if grappled_actor:
			player.grappling_hook.drop_actor()
			grappled_actor.get_shoved((player.get_global_mouse_position() - grappled_actor.global_position).normalized() * shove_strength)
	elif event.is_action_pressed("alt_attack"):
		controller.change_to("Mace")

func _on_GrapplingHook_drop_body() -> void:
	controller.change_to("Default")
