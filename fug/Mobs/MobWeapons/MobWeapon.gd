extends Node2D

class_name MobWeapon

signal hit(actor)
signal done

@export var damage : int = 100

var _ignored_actors = []

var _on_hit : Callable
var is_attacking : get = is_attacking_get

func attack(on_hit_callback := self._on_hit_default) -> void:
	is_attacking = true
	_on_hit = on_hit_callback

func interrupt_attack() -> void:
	if not is_attacking : return
	attack_done()

func attack_done() -> void:
	is_attacking = false
	done.emit()

func _on_hit_default(actor : Actor) -> void:
	if _is_ignored(actor): return
	actor.hit(damage)
	hit.emit(actor)

func on_hit(actor : Actor) -> void:
	_on_hit.call(actor)

func is_attacking_set(value):
	is_attacking = value

func is_attacking_get() -> bool:
	return is_attacking

func _is_ignored(actor : Actor) -> bool:
	return actor in _ignored_actors

func ignore_actor(actor : Actor) -> void:
	if not actor:
		print("Can't ignore non actor %s", actor)
	_ignored_actors.append(actor)
