extends GrapplingHookState

@export var retract_curve : Curve
@export var retract_time : float = 0.5
@export var min_retract_time : float = 0.3
# the distance to which the retraction time is calculated
@export var nominated_retract_dist : float = 100

var _target_position : Vector2

@onready var _retract_animation : AnimatedCurve

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_target_position = grappling_hook.collider.global_position
	var _retract_time = retract_time * (_target_position - grappling_hook.global_position).length() / nominated_retract_dist
	_retract_time = max(min_retract_time, _retract_time)
	_retract_animation = AnimatedCurve.new(retract_curve, _retract_time)
	_retract_animation.reset()
	
func process(_delta : float) -> void:
	update_line_renderer()

func physics_process(delta : float) -> void:
	var done = _move_hook(delta)
	
	grappling_hook.move_actor_to(grappling_hook.collider.global_position, delta)
	
	if done:
		grappling_hook.done.emit()
		if grappling_hook.has_actor:
			controller.change_to("Shield")
		else:
			controller.change_to("Idle")

func _move_hook(delta : float) -> bool:
	# returns if the retraction is completed
	var done := _retract_animation.update(delta)
	_target_position = update_target_position(delta, _target_position)
	# TODO: perhaps just lerp the position and don't use curve?
	var hook_to_target := _target_position - grappling_hook.global_position
	var normalized_position := _retract_animation.value
	var target_distance := (hook_to_target.length() - grappling_hook.shield_dist) * normalized_position
	grappling_hook.collider.position = Vector2.RIGHT * (target_distance + grappling_hook.shield_dist)
	grappling_hook.rotation = hook_to_target.angle()
	return done

func on_Parent_body_entered(body: Node) -> void:
	if grappling_hook.has_actor: return
	if body is Actor:
		grappling_hook.grab_actor(body)
