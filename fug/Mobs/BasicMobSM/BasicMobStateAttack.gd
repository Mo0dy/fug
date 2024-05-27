extends State

@onready var _mob : BasicMob = owner as BasicMob
@onready var attack_delay : float = 0.2

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_mob.movement_controller.target_speed = Vector2.ZERO
	_mob.play_animation("Attack")
	
	var anim_time = Util.get_animation_time(_mob.animator, "Attack")
	if anim_time <= attack_delay:
		print("ERROR: won't attack if animation time is less then attack_delay")
	
	_callback(_mob.weapon.attack, attack_delay)
	_callback(controller.change_to, anim_time, ["Target"])

