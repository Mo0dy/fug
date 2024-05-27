extends GrapplingHookState

@export var distance_curve : Curve
@export var angle_curve : Curve

@export var max_range : float = 100
@export var attack_time : float = 0.6
@export var attack_angle : float = PI / 8

var _target_position : Vector2

var _distance_animation: AnimatedCurve
var _angle_animation: AnimatedCurve

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	# _distance_animation = AnimatedCurve.new(distance_curve, attack_time)
	# _angle_animation = AnimatedCurve.new(angle_curve, attack_time, attack_angle)
	_distance_animation.reset()
	_angle_animation.reset()
	_target_position = grappling_hook.get_global_mouse_position()
	_enforce_max_range()
	
	if grappling_hook.has_actor:
		grappling_hook.grappled_actor.be_weapon()

func leave() -> void:
	super.leave()
	if grappling_hook.has_actor:
		grappling_hook.grappled_actor.be_grappled()

func physics_process(delta : float) -> void:
	var done := _distance_animation.update(delta)
	_angle_animation.update(delta)
	
	_target_position = update_target_position(delta, _target_position)
	_enforce_max_range()
	
	# TODO: include the grappling hook initial position?
	var hook_to_target = _target_position - grappling_hook.global_position
	hook_to_target *= _distance_animation.value
	hook_to_target = hook_to_target.normalized() * (hook_to_target.length() + grappling_hook.shield_dist)
	hook_to_target = hook_to_target.rotated(_angle_animation.value)
	
	grappling_hook.move_actor_to(hook_to_target + grappling_hook.global_position, delta)
	grappling_hook.fix_to_collider()
	
	update_line_renderer()
	
	if done:
		grappling_hook.done.emit()
		if grappling_hook.has_actor:
			controller.change_to("Shield")
		else:
			controller.change_to("Idle")

# TODO: move to some sort of common state with attack
func _enforce_max_range() -> void:
	# moves target position so that it stays in max range.
	# Might be weird while dashing and thuse need to be replaced by something different.
	var hook_to_target := _target_position - grappling_hook.global_position
	if hook_to_target.length() > max_range:
		_target_position = hook_to_target.normalized() * max_range + grappling_hook.global_position
