extends Node2D

@export var leading_multiplier := 0.25
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	position = (get_global_mouse_position() - get_parent().position) * leading_multiplier
