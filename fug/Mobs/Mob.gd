extends Actor

class_name Mob

@export var perception_range : float = 500

func _ready() -> void:
	# register self on game manager
	if GameManager.level_manager:
		GameManager.level_manager.register_mob(self)

func can_see_player() -> bool:
	return can_see(GameManager.player)

func can_see(actor : Actor) -> bool:
	if global_position.distance_to(actor.global_position) > perception_range:
		return false
	return super.can_see(actor)

func pick_walk_direction(amount : int, max_dist_effect : float) -> float:
	# changse: angle dictionary
	var distances = {}
	var total_distance = 0
	for i in range(amount):
		var angle = randf_range(0, 2 * PI)
		var distance = max(measure_distance(Vector2.RIGHT.rotated(angle)), max_dist_effect)
		distances[distance] = angle
		total_distance += distance
	var changses = {}
	for dist in distances:
		changses[dist / total_distance] = distances[dist]
	
	var rand_val := randf_range(0, 1)
	
	for changse in changses:
		if changse > rand_val:
			return changses[changse]
		rand_val -= rand_val
	return 0.0
