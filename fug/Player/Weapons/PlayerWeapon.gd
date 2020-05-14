extends Node2D

class_name PlayerWeapon

signal hit(actor)
signal done

export var damage : int = 100

var _on_hit : FuncRef
var _is_attacking := false
var is_attacking : bool setget , get_is_attacking

func attack(on_hit_callback := funcref(self, "_on_hit_default")) -> void:
	_on_hit = on_hit_callback
	_is_attacking = true

func dash_attack(on_hit_callback := funcref(self, "_on_dash_hit_default")) -> void:
	_on_hit = on_hit_callback
	_is_attacking = true

func interrupt_attack() -> void:
	.interrupt_attack()
	attack_done()

func attack_done() -> void:
	_is_attacking = false
	emit_signal("done")

func _on_hit_default(actor : Actor) -> void:
	actor.hit(damage)
	emit_signal("hit", actor)

func _on_dash_hit_default(actor : Actor) -> void:
	actor.hit(damage)
	emit_signal("hit", actor)

func on_hit(actor : Actor) -> void:
	_on_hit.call_func(actor)

func get_is_attacking() -> bool:
	return _is_attacking
