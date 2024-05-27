extends State

# export var min_kill_velocity = 200

@onready var _mob : BasicMob = owner as BasicMob

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_mob.play_animation("Idle")
	_mob.body_weapon.attack()
	_mob.movement_controller.enabled = false

func leave() -> void:
	super.leave()
	_mob.movement_controller.enabled = true
	_mob.body_weapon.interrupt_attack()

#func physics_process(delta : float) -> void:
#	var speed := _mob.movement_controller.get_speed()
#	if _mob.body_weapon.is_attacking && speed < min_kill_velocity:
#		_mob.body_weapon.interrupt_attack()
#	if speed == 0:
#		_end_shove()
#		return
#
#func _end_shove() -> void:
#	controller.change_to("Death")
