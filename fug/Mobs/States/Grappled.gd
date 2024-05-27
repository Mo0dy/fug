extends MobState

class_name MobStateGrappled

var _previous_collision_mask : int
var _previous_collision_layer : int

func enter(controller_ : StateMachine):
	super.enter(controller_)
	mob.play_animation("Idle")
	_previous_collision_mask = mob.collision_mask
	_previous_collision_layer = mob.collision_layer
	mob.collision_mask = 0
	mob.collision_layer = 16

func leave() -> void:
	super.leave()
	mob.collision_mask = _previous_collision_mask
	mob.collision_layer = _previous_collision_layer
