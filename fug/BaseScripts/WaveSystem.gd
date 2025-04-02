extends Node

class_name WaveSystem

signal wave_starting(wave_count)
signal wave_ending(wave_count)

# all subnodes are considered to be valid spawn points ?
# waves go from 1 - n for the nth wave

# Maybe all the curves should either be linear or just use the same curve? idk.
@export var curve_domain : int = 20
@export var difficulty_prop_curve : Curve
@export var health_curve : Curve
@export var wave_spawn_count_curve : Curve
@export var max_concurrent_enemies_curve : Curve

# these values are used outside of the curve domain
@export var per_wave_health_increase : float = 0.10
@export var per_wave_spawncount_increase : int = 10
@export var per_wave_concurrent_enemies_increase : int = 2

@export var wave_timeout_s: float = 10

# TODO: this should probably also be a curve ffs
@export var avg_per_second_spawns : float = 2

@onready var spawnpoints : Array[Node] = get_children()

var wave_counter : int = 0
var is_wave_ongoing := false
var wave_timeout_timer : Timer

# hold the current difficulty settings per wave
var difficulty_prop : float = 0
var health : float = 0
var wave_spawn_count : int = 0
var concurrent_enemies : int = 0

# needed since the mobds need a frame to be instantiated (and registered in the game manager)
var last_frame_spawned : bool = false


func _ready() -> void:
	init()

func init() -> void:
	wave_counter = 0
	is_wave_ongoing = false

func _process(delta : float) -> void:
	if not is_wave_ongoing:
		return

	if _is_wave_over():
		end_wave()
		return

	last_frame_spawned = false

	var spawn_changse = avg_per_second_spawns * delta
	while spawn_changse > 0:
		spawn_changse -= randf_range(0, 1)
		if not _can_spawn():
			break
		if spawn_changse > 0:
			_spawn_enemy()

func _is_wave_over() -> bool:
	return (not last_frame_spawned) and wave_spawn_count == 0 and len(GameManager.level_manager.mobs) == 0

func _can_spawn():
	return is_wave_ongoing and wave_spawn_count > 0

func _spawn_enemy():
	wave_spawn_count -= 1
	last_frame_spawned = true
	# HACK: works as long as most spawnpoints can spawn
	for i in range(10):
		var spawnpoint = spawnpoints[randi() % spawnpoints.size()]
		if spawnpoint.can_spawn():
			spawnpoint.spawn()
			break


func next_wave() -> void:
	wave_counter += 1
	
	# calculate difficulty settings from wave_count
	if wave_counter <= curve_domain:
		@warning_ignore("integer_division")
		var normalized_wave_counter := (wave_counter - 1) / (curve_domain - 1)
		difficulty_prop = difficulty_prop_curve.sample(normalized_wave_counter)
		health = health_curve.sample(normalized_wave_counter)
		wave_spawn_count = int(wave_spawn_count_curve.sample(normalized_wave_counter))
		concurrent_enemies = int(max_concurrent_enemies_curve.sample(normalized_wave_counter))
	else:
		var wave_offset := wave_counter - curve_domain
		# NOTE: difficulty prop for waves outside the wave domain is always 100%
		difficulty_prop = 1
		health = health_curve.interpolate_baked(1) + per_wave_health_increase * wave_offset
		wave_spawn_count = int(wave_spawn_count_curve.interpolate_baked(1) + per_wave_spawncount_increase * wave_offset)
		concurrent_enemies = int(max_concurrent_enemies_curve.interpolate_baked(1) + \
								per_wave_concurrent_enemies_increase * wave_offset)
	
	print("Wave " + str(wave_counter) + " difficulty: " + str(difficulty_prop) + " health: " + str(health) + \
			" wave_spawn_count: " + str(wave_spawn_count) + " concurrent_enemies: " + str(concurrent_enemies))
	is_wave_ongoing = true
	wave_starting.emit(wave_counter)

	# TODO: maybe this should be somewhere else ... IDK
	GameManager.level_manager.popup_text.display_text("Wave " + str(wave_counter), 2)

func end_wave() -> void:
	print("Wave " + str(wave_counter) + " ended")
	is_wave_ongoing = false
	wave_ending.emit(wave_counter)

	GameManager.level_manager.popup_text.display_text("Wave " + str(wave_counter) + " ended", 2)

	await get_tree().create_timer(wave_timeout_s).timeout

	next_wave()
