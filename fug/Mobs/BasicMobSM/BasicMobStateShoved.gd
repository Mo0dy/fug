extends BasicMobStateDeath

@export var hit_velocity_loss : float = 50
@export var min_kill_velocity = 200

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_mob.body_weapon.connect("hit", Callable(self, "_on_BodyWeapon_hit"))
	_mob.body_weapon.attack()
	_mob.movement_controller.mode = BasicMobMC.Mode.FRICTION

func leave() -> void:
	super.leave()
	_mob.body_weapon.disconnect("hit", Callable(self, "_on_BodyWeapon_hit"))
	_mob.movement_controller.mode = BasicMobMC.Mode.CONTROL
	_mob.body_weapon.interrupt_attack()

func physics_process(_delta : float) -> void:
	var speed := _mob.movement_controller.get_velocity()
	
	# Velocity loss on inital collision (with wall)
	if _mob.movement_controller.has_collided && ! _mob.movement_controller.has_collided_last_update:
		_mob.movement_controller.slowdown(_mob.movement_controller.get_velocity() / 2)
	
	if _mob.body_weapon.is_attacking && speed < min_kill_velocity:
		_mob.body_weapon.interrupt_attack()
	if speed == 0:
		_end_shove()
		return

func _on_BodyWeapon_hit(body : Actor) -> void:
	if not body: return
	_mob.movement_controller.slowdown(hit_velocity_loss)

func _end_shove() -> void:
	controller.change_to("Death")
