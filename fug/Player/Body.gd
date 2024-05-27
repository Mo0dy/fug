extends Node2D


func _ready():
	pass # Replace with function body.


func _process(delta):
	var delta_angle = get_angle_to(get_global_mouse_position())
	# HACK: don't use lerp / multiply by delta here or use a proper formula
	rotation += lerp(0.0, delta_angle, 20 * delta)
