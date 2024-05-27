extends State

@onready var _sword = owner as Sword

func enter(controller_ : StateMachine):
	super.enter(controller_)
	_sword.collider_attack.set_deferred("disabled", true)
	_sword.collider_shove.set_deferred("disabled", true)
