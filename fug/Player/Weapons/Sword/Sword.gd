extends PlayerWeapon

class_name Sword

@onready var hit_area := $HitArea
@onready var collider_attack := $HitArea/ColliderAttack
@onready var collider_shove := $HitArea/ColliderShove
@onready var _state_machine : StateMachine = $StateMachine

@onready var attack_audio := $Audio

# TOTO: fixme: shouldn't the states themselves decide what to do?

func attack(on_hit_callback := self._on_hit_default) -> void:
	super.attack(on_hit_callback)
	# TODO fixme
	_state_machine.change_to("Attack")

func dash_attack(on_hit_callback := self._on_dash_hit_default) -> void:
	super.dash_attack(on_hit_callback)
	# TODO fixme
	_state_machine.change_to("Shove")

func interrupt_attack() -> void:
	# TODO fixme
	_state_machine.change_to("Default")
