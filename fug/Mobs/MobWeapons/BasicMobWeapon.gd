extends MobWeapon

@export var windup_time : float = 0.2
@export var attack_time : float = 0.1

@onready var _collider : CollisionShape2D = $Area3D/Collider
@onready var _area : Area2D = $Area3D

# NOTE: the basic attack assumes that there is no atack issued during the attack

func _ready() -> void:
	_collider.set_deferred("disabled", true)
	_area.connect("body_entered", Callable(self, "_on_Area_body_entered"))

func interrupt_attack() -> void:
	print("ERROR: Can't interrupt a BasicMobAttack!")

func attack(on_hit_callback := self._on_hit_default) -> void:
	super.attack(on_hit_callback)
	await get_tree().create_timer(windup_time).timeout
	_collider.set_deferred("disabled", false)
	await get_tree().create_timer(attack_time).timeout
	_collider.set_deferred("disabled", true)
	attack_done()

func _on_Area_body_entered(body : Actor) -> void:
	if not body: return
	if not is_attacking : return
	on_hit(body)
