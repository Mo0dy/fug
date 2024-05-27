extends State

@export var min_wait_time : float = 1
@export var max_wait_time : float = 10

@onready var _mob : BasicMob = owner as BasicMob

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_mob.movement_controller.stop()
	_mob.play_animation("Idle")
	_callback(self._continue_walking, randf_range(min_wait_time, max_wait_time))

func physics_process(_delta: float) -> void:
	if _mob.can_see_player():
		change_to("Target")

func _continue_walking() -> void:
	_mob.rotation = _mob.pick_walk_direction(3, 500)
	change_to("Walk")
