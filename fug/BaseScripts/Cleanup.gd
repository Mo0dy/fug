extends Node

@export var origin_distance := 10000

func _process(delta: float) -> void:
	if owner.position.length() > origin_distance:
		queue_free()
