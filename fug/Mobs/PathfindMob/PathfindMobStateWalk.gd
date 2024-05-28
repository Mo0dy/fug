extends State

@export var speed : float = 100
@export var target_speed : float = 150
@export var attack_timeout : float = 0.75
@export var attack_distance : float = 20

# TODO: fixme
@export var navigation_agent: NavigationAgent2D

var _speed := speed
var _can_attack : float

@onready var _mob : BasicMob = owner as BasicMob

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_mob.play_animation("Walk")
	_can_attack = false
	_callback(self._allow_attack, attack_timeout)

func _allow_attack() -> void:
	_can_attack = true

func process(delta : float) -> void:
	super.process(delta)
	# TODO: fixme
	if not navigation_agent:
		return
	if GameManager.player:
		navigation_agent.target_position = GameManager.player.position

func physics_process(_delta: float) -> void:
	# TODO: fixme
	if not navigation_agent:
		print("No navigation agent")
		return
	if not navigation_agent.is_navigation_finished():
		var goal_pos = navigation_agent.get_next_path_position()
		_mob.movement_controller.target_speed = (goal_pos - _mob.global_position).normalized() * _speed;
	if _mob.can_see_player():
		_speed = target_speed
	else:
		_speed = speed
	
	# NOTE: both the sight calculation and the distance calculation could be done cheaper with the path!
	var delta_player : Vector2 = GameManager.player.position - _mob.position
	var dist = delta_player.length()
	
	if dist < attack_distance && _can_attack:
		controller.change_to("Attack")
