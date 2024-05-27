extends PlayerState

class_name MoveState

func enter(controller_: StateMachine) -> void:
	super.enter(controller_)
	player.play_animation("Idle")

func process(delta : float) -> void:
	super.process(delta)
	_handle_inputs()

func _handle_inputs() -> void:
	var _movement_target := Vector2()
	if Input.is_action_pressed("up"):
		_movement_target += Vector2.UP
	if Input.is_action_pressed("down"):
		_movement_target += Vector2.DOWN
	if Input.is_action_pressed("right"):
		_movement_target += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		_movement_target += Vector2.LEFT
	player.movement_controller.run_direction(_movement_target)
	player.movement_controller.body_look_at(player.get_global_mouse_position())
