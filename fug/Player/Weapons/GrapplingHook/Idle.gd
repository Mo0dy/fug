extends GrapplingHookState

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	grappling_hook.hide()
	grappling_hook.set_collider_disabled(true)
