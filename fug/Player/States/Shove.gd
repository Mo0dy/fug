extends PlayerState

# For now this mode can only be accessed via attack -> dash
@export var shove_strength : float = 480
@export var dash_time : float = 0.5
@export var dash_chain_multiplier : float = 2

@onready var _sound_shove := $SoundShove

func enter(controller_ : StateMachine) -> void:
	# HACK: there should be a better way to do these references
	player.weapon.dash_attack(self._on_Sword_hit)
	super.enter(controller_)
	player.play_animation("Shove")
	var direction := (player.get_global_mouse_position() - player.global_position).normalized()
	
	if controller.last_state == "Dash" or controller.last_state == "Limbo":
		player.movement_controller.dash(direction, dash_time, dash_chain_multiplier)
	else:
		player.movement_controller.dash(direction, dash_time)
	player.movement_controller.body_target = direction
	player.movement_controller.connect("state_change", Callable(self, "on_Player_state_change"))

func leave() -> void:
	super.leave()
	# disconnect before changing player state
	player.movement_controller.disconnect("state_change", Callable(self, "on_Player_state_change"))
	player.movement_controller.change_state(PlayerDefaultMC.MOVING)
	player.weapon.interrupt_attack()
	
func on_Player_state_change(new_state) -> void:
	# player has ended the dash himself
	if new_state != PlayerDefaultMC.DASHING:
		controller.change_to("Default")

func _on_Sword_hit(body : Actor):
	# this will call a change state here via the message
	# for now just fling away from other position
	var dir = ((body.global_position - player.position) + Vector2.RIGHT.rotated(player.rotation)).normalized()
	body.get_shoved(dir * shove_strength)
	controller.change_to("Limbo")
	_sound_shove.play()
