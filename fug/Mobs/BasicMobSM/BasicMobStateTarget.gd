extends State

@export var speed : float = 150
@export var attack_timeout : float = 0.75
@export var attack_distance : float = 20
@export var untarget_distance : float = 350
@onready var _mob : BasicMob = owner as BasicMob

var _can_attack = false

func enter(controller_: StateMachine) -> void:
	super.enter(controller_)
	_mob.play_animation("Walk")
	_can_attack = false
	_callback(self._allow_attack, attack_timeout)

func _allow_attack() -> void:
	_can_attack = true

func process(delta : float) -> void:
	super.process(delta)
	var player := GameManager.player
	if not _mob.can_see_player():
		controller.change_to("Reorient")
		return
	
	var delta_player := GameManager.player.position - _mob.position
	_mob.movement_controller.target_speed = delta_player.normalized() * speed
	
	if _mob.movement_controller.get_velocity() > 5:
		_mob.play_animation("Walk")
	else:
		_mob.play_animation("Idle")
	
	var dist = delta_player.length()
	
	if dist < attack_distance:
		if _can_attack:
			controller.change_to("Attack")
