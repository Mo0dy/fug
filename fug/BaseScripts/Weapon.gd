extends Area2D

class_name Weapon

signal hit
signal done

@export var attack_time : float = 0.2

var _attacking := false
var _attack_time : float

@onready var _collider : CollisionShape2D = $Area3D

func _ready() -> void:
	_collider.disabled = true
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta : float) -> void:
	if not _attacking: return
	
	_attack_time += delta
	if _attack_time >= attack_time:
		stop_attack()
	
func _on_body_entered(body: Node) -> void:
	# TODO: damage calculation / other stuff here. This will probably just be
	# overwritten by the children
	
	# Maybe this should be replaced by some sort of hittable interface / class
	if body.has_method("hit"):
		body.hit()
		hit.emit()

func attack() -> void:
	_collider.set_deferred("disabled", false)
	_attacking = true
	_attack_time = 0

func stop_attack() -> void:
	_attacking = false
	_collider.set_deferred("disabled", true)
	done.emit()
