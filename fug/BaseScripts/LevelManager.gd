extends Node

class_name LevelManager

signal money_changed(new_money)

@export var spawn_limit : int = 50

@onready var player : Player = $Player
@onready var wave_system : WaveSystem = $WaveSystem

var _money : int = 0
var mobs = []

func _ready() -> void:
	GameManager.level_manager = self
	player.connect("death", Callable(self, "_on_Player_death"))
	
	# HACK: just for testing here
	if wave_system:
		wave_system.next_wave();

func _on_Player_death(_actor) -> void:
	GameManager.scene_changer.change_to_main_menu(2)

func register_mob(mob : Mob) -> void:
	mob.connect("death", Callable(self, "_on_Mob_death"))
	if not mob in mobs:
		mobs.append(mob)

func is_spawning_allowed() -> bool:
	return len(mobs) < spawn_limit

func _on_Mob_death(mob : Mob) -> void:
	# TODO: this should be it's own thing
	add_money(100)
	mobs.erase(mob)

func add_money(amount : int) -> void:
	if amount < 0:
		print("CAN NOT ADD NEGATIVE MOENY!!")
		return
	_money += amount
	money_changed.emit(_money)

func sub_money(amount : int) -> bool:
	# subtracts money from the player returns true if the player had enough money.
	if amount < 0:
		print("CAN NOT SUBTRACT NEGATIVE MOENY!!")
		return false
	
	if amount > _money:
		return false
	
	_money -= amount
	money_changed.emit(_money)
	return true
