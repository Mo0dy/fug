extends CharacterBody2D

class_name Actor

signal death(actor)

@export var max_hp : int = 100

var _hp : int = max_hp

# This will get restored by _set_normal_physics()
@onready var _default_collision_layer := collision_layer
@onready var _default_collision_mask := collision_mask

func hit(damage : int) -> void:
	_hp = max(0, _hp - damage)
	if _hp == 0:
		die()

func burn(_damage : int) -> void:
	pass

func die() -> void:
	death.emit(self)
	collision_layer = 0
	collision_mask = Util.LAYER_WALLS

func get_shoved(_impulse : Vector2) -> void:
	die()

func be_shield() -> void:
	pass

func be_weapon() -> void:
	pass

func be_grappled() -> bool:
	# returns true if the grapple has succeeded
	return false

func be_ungrappled() -> void:
	_reset_physics()

func _reset_physics() -> void:
	collision_layer = _default_collision_layer
	collision_mask = _default_collision_mask
	
func can_see(actor : Actor) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		actor.global_position,
		Util.LAYER_WALLS
		)
	var result = space_state.intersect_ray(query)
	return result.is_empty()

func measure_distance(direction : Vector2, max_range : float = 10000) -> float:
	# NOTE: max range is reltive to direction vector length
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + direction * max_range,
		Util.LAYER_WALLS
		)
	var result = space_state.intersect_ray(query)
	if result.is_empty():
		return INF
	return result["position"].distance_to(global_position)

# Actor status flags
var status_is_frenzy: bool = false
var status_is_zombie: bool = false
