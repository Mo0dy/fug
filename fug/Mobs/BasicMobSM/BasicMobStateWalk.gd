extends State

@export var speed : float = 100
@export var target_distance : float = 250

@export var min_walk_time : float = 0.75
@export var max_walk_time : float = 3

# TODO: randomize
@export var min_wall_stop_distance : float = 75

@export var min_direction_change := 0
@export var max_direction_change := PI / 6

@onready var _mob : BasicMob = owner as BasicMob

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_mob.play_animation("Walk")
	_mob.rotation += randf_range(min_direction_change, max_direction_change) * (randi() % 2 * 2 - 1)
	_mob.movement_controller.target_speed = Vector2.RIGHT.rotated(_mob.rotation) * speed
	_callback(self._change_to_idle, randf_range(min_walk_time, max_walk_time))

func _change_to_idle() -> void:
	change_to("Idle")

func physics_process(delta: float) -> void:
	if _mob.can_see_player():
		change_to("Target")
	if _mob.measure_distance(Vector2.RIGHT.rotated(_mob.rotation)) < min_wall_stop_distance:
		change_to("Idle")
 
