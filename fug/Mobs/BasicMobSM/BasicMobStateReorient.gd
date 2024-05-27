extends State

@export var speed : float = 120
@export var interest_timeout : float = 3
@export var epsilon : float = 10

@onready var _mob : BasicMob = owner as BasicMob

var last_player_pos : Vector2
var last_player_dir : Vector2

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	# HACK: we should really save the last position the player was seen at.
	last_player_pos = GameManager.player.global_position
	last_player_dir = Vector2.RIGHT * GameManager.player.get_player_rotation()

func physics_process(_delta : float) -> void:
	var delta_last_player_pos := last_player_pos - _mob.position
	_mob.movement_controller.target_speed = delta_last_player_pos.normalized() * speed
	
	if _mob.can_see_player():
		change_to("Target")
	
	if delta_last_player_pos.length() < epsilon:
		_mob.movement_controller.target_look = last_player_dir
		change_to("Walk")
