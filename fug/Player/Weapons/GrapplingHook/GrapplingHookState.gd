extends State

class_name GrapplingHookState

@export var reaction_curve : Curve
@export var max_change_speed : float = 500
@export var reaction_curve_domain : float = 80

@onready var grappling_hook : GrapplingHook = owner

func _get_target_move_speed(target_distance : float) -> float:
	if target_distance > reaction_curve_domain:
		return max_change_speed
	return reaction_curve.sample(target_distance / reaction_curve_domain) * max_change_speed

func update_target_position(delta : float, target_position : Vector2) -> Vector2:
	# todo: update angle and distance seperately
	var offset_vector :=  grappling_hook.get_global_mouse_position() - target_position
	var offset_distance := offset_vector.length()
	
	var new_target_position = target_position
	
	if offset_distance:
		var target_move := _get_target_move_speed(offset_distance) * offset_vector.normalized() * delta
		if target_move.length() > offset_distance:
			new_target_position += offset_vector
		else:
			new_target_position += target_move
	return new_target_position

func update_line_renderer() -> void:
	grappling_hook.line.points[1] = grappling_hook.collider.position
