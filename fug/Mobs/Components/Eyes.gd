extends Node2D

class_name Eyes

func can_see(actor : Actor) -> bool:
	# if use_perception_range && global_position.distance_to(actor.global_position) > perception_range:
	# 	return false
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		actor.global_position,
		Util.LAYER_WALLS
		)
	var result = space_state.intersect_ray(query)
	return result.is_empty()

func can_see_player() -> bool:
	return can_see(GameManager.player)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
