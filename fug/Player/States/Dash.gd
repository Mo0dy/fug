extends PlayerState


var _direction : Vector2
# the distance moved through the curve (normalized)

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_direction = Vector2()
	if Input.is_action_pressed("up"):
		_direction += Vector2.UP
	if Input.is_action_pressed("down"):
		_direction += Vector2.DOWN
	if Input.is_action_pressed("right"):
		_direction += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		_direction += Vector2.LEFT
	_direction = _direction.normalized()
	player.movement_controller.dash(_direction)
	player.movement_controller.connect("state_change", Callable(self, "on_Player_state_change"))

func leave() -> void:
	super.leave()
	player.movement_controller.disconnect("state_change", Callable(self, "on_Player_state_change"))

func unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("attack"):
		controller.change_to("Shove")

func on_Player_state_change(new_state) -> void:
	if new_state != PlayerDefaultMC.DASHING:
		controller.change_to("Default")
