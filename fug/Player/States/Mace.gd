extends MoveState

@export var shove_strength : float = 650

@onready var _sound_shove = $SoundShove

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	player.grappling_hook.connect("done", Callable(self, "_on_GrapplingHook_done"))
	player.grappling_hook.mace()

func leave() -> void:
	super.leave()
	player.grappling_hook.disconnect("done", Callable(self, "_on_GrapplingHook_done"))

func process(delta : float) -> void:
	super.process(delta)
	if player.weapon.is_attacking: return
	if player.movement_controller.get_velocity() > 5:
		player.play_animation("Walking")
	else:
		player.play_animation("Idle")

func _on_GrapplingHook_done() -> void:
	controller.change_to("Shield")

func unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("attack") && not player.weapon.is_attacking:
		player.weapon.attack(self._on_Sword_hit)
		player.play_animation("Attack")

func _on_Sword_hit(body : Actor) -> void:
	if body == player.grappling_hook.grappled_actor:
		player.grappling_hook.drop_actor()
		body.get_shoved((player.get_global_mouse_position() - body.global_position).normalized() * shove_strength)
		GameManager.slowdown()
		_sound_shove.play()
	else:
		player.weapon._on_hit_default(body)
