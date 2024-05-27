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
@export var max_concurrent_enemies : int = 80

# TODO: this should probably also be a curve ffs
@export var avg_per_second_spawns : float = 2

var wave_counter : int = 0
var is_wave_ongoing := false

# hold the current difficulty settings per wave
var difficulty_prop : float = 0
var health : float = 0
var wave_spawn_count : int = 0
var concurrent_enemies : int = 0

func _ready() -> void:
	init()

func init() -> void:
	wave_counter = 0
	is_wave_ongoing = false

func _process(delta : float) -> void:
	var spawn_changse = avg_per_second_spawns * delta
	
	while spawn_changse > 0:
		spawn_changse -= randf_range(0, 1)
		if spawn_changse > 0:
			_spawn_enemie()

func _spawn_enemie():
	if wave_spawn_count == 0: return
	wave_spawn_count -= 1
	# TODO: spawn enemie and let the level manager know.
	print("spawn enemie")

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
	
	is_wave_ongoing = true
	wave_starting.emit(wave_counter)

func end_wave() -> void:
	is_wave_ongoing = false
	wave_ending.emit(wave_counter)
