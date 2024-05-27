extends GrapplingHookState

@export var angular_tension = 15
@export var linear_tension_pulling = 15

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	grappling_hook.grappled_actor.be_shield()
	grappling_hook.connect("drop_body", Callable(self, "_on_GrapplingHook_drop_body"))

func leave() -> void:
	super.leave()
	grappling_hook.disconnect("drop_body", Callable(self, "_on_GrapplingHook_drop_body"))

func physics_process(delta : float) -> void:
	var target_vec := grappling_hook.get_global_mouse_position() - grappling_hook.global_position
	var current_vec := grappling_hook.grappled_actor.global_position - grappling_hook.global_position
	var delta_angle = current_vec.angle_to(target_vec)
	delta_angle = lerp(0.0, delta_angle, angular_tension * delta)
	
	# TODO: maybe give some mouse control over the distance?
	var delta_distance := grappling_hook.shield_dist - current_vec.length()
	# if pulling closer don't do it instantly
	if delta_distance < 0:
		delta_distance = lerp(0.0, delta_distance, linear_tension_pulling * delta)
	var new_distance : float = current_vec.length() + delta_distance
	
	var new_position := current_vec.rotated(delta_angle).normalized() * new_distance
	new_position += grappling_hook.global_position
	grappling_hook.move_actor_to(new_position, delta)
	grappling_hook.fix_to_collider()
	update_line_renderer()

func _on_GrapplingHook_drop_body() -> void:
	controller.change_to("Idle")
