extends Node2D

class_name Spawnpoint

@export var mob_scene: PackedScene
@export var is_active := true

# parent node ... hopefully
@onready var wave_system : WaveSystem = get_parent()

func _ready() -> void:
	assert(mob_scene, "mob_scene has not been supplied")
	assert(wave_system, "wave_system not found for spawnpoint")

func can_spawn() -> bool:
	return is_active

func spawn() -> void:
	var mob = mob_scene.instantiate()
	GameManager.level_manager.call_deferred("add_child", mob)
	mob.rotation = randf_range(0, PI * 2)
	mob.position = position
	mob.on_spawn(wave_system.health, wave_system.difficulty_prop)
