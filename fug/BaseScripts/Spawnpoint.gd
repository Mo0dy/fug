extends Node2D

class_name Spawnpoint

@export var mob_scene: PackedScene
@export var is_active := true
@export var spawn_time : float = 5

@export var spawn_amount : int = 20
@export var endless_spawn := false

func _ready() -> void:
	$Timer.wait_time = spawn_time

func _on_Timer_timeout() -> void:
	if is_active && _can_spawn():
		_spawn()
		if not endless_spawn:
			spawn_amount -= 1

func _can_spawn() -> bool:
	var spawn_allowed := true
	if not endless_spawn:
		spawn_allowed = spawn_amount > 0
	if GameManager.level_manager:
		spawn_allowed = spawn_allowed && GameManager.level_manager.is_spawning_allowed()
	return spawn_allowed

func _spawn() -> void:
	var mob = mob_scene.instantiate()
	GameManager.level_manager.call_deferred("add_child", mob)
	# GameManager.level_manager.add_child(mob)
	mob.rotation = randf_range(0, PI * 2)
	mob.position = position
