extends Node2D

class_name Spawnpoint

@export var mob_scene: PackedScene
@export var is_active := true

func can_spawn() -> bool:
	return is_active

func spawn() -> void:
	var mob = mob_scene.instantiate()
	GameManager.level_manager.call_deferred("add_child", mob)
	mob.rotation = randf_range(0, PI * 2)
	mob.position = position
