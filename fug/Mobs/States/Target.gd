extends MobState

@export var speed : float = 100
@export var untarget_distance : float = 1000
@export var attack_distance : float = 20
@export var attack_timeout : float = 1

var _can_attack := false
var _is_moving := true

func enter(controller_: StateMachine) -> void:
	super.enter(controller_)
	mob.play_animation("Walk")
	
	# not sure it this way of doing things is "threadsave"
	_can_attack = false
	_callback(self._allow_attack, attack_timeout)

func _allow_attack() -> void:
	_can_attack = true

func process(delta : float) -> void:
	super.process(delta)
	var player := GameManager.player
	var dist = (player.position - owner.position).length()
	_is_moving = true
	mob.play_animation("Walk")
	if dist < attack_distance:
		mob.play_animation("Idle")
		_is_moving = false
		if _can_attack:
			controller.change_to("Attack")
	# TODO: replace with collision check
	elif dist > untarget_distance:
		controller.change_to("Default")

func physics_process(delta: float) -> void:
	# just move forward  . . .		
	owner.look_at(GameManager.player.position)
	if _is_moving:
		owner.set_velocity(Vector2.RIGHT.rotated(owner.rotation) * speed)
		owner.move_and_slide()
		owner.velocity
	
