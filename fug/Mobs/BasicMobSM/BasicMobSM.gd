extends Mob

class_name BasicMob

@onready var movement_controller : BasicMobMC = $MovementController
@onready var weapon : MobWeapon = $Weapon
@onready var animator := $AnimatedSprite2D
@onready var _state_machine : StateMachine = $StateMachine
@onready var hit_audio := $Hit
@onready var death_audio := $Death
@onready var body_weapon : BodyWeapon = $BodyWeapon

func _ready() -> void:
	super._ready()
	body_weapon.ignore_actor(self)

func die() -> void:
	super.die()
	if not _state_machine.is_current_state("Death") and not _state_machine.is_current_state("Shoved"):
		_state_machine.change_to("Death")

func play_animation(animation : String) -> void:
	animator.play(animation)

func be_grappled() -> bool:
	_state_machine.change_to("Weaponized")
	return true

func be_shield() -> void:
	_state_machine.change_to("Grappled")

func be_weapon() -> void:
	_state_machine.change_to("Weaponized")

func get_shoved(impulse : Vector2) -> void:
	die()
	# TODO: add actor mass (maybe move this method to actor too?)
	movement_controller.speed = impulse
	_state_machine.change_to("Shoved")
