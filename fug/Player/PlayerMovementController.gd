extends Node

class_name PlayerDefaultMC

signal state_change(new_state)

@export var speed : float = 150
@export var acceleration : float = 20
@export var dash_timeout : float = 0.5
@export var body_rotate_acceleration : float = 20

@export var dash_dist : float = 120
@export var dash_time : float = 0.2
@export var dash_curve : Curve = Curve.new()

enum { IDLE, MOVING, DASHING }

var _state = MOVING

var movement_target := Vector2()
# The vector gives the direction that the player is looking in.
var body_target := Vector2()
var _movement := Vector2()

var _dash_direction : Vector2
var _dash_time : float
var _dash_curve_position : float
var _dash_dist

# can't dash if this is positive
var _dash_timeout : float = 0
var can_dash : bool: get = can_dash_get

# gets set via dependency injection
var _player : CharacterBody2D
var _body : Node2D

func init(player : CharacterBody2D, body : Node2D) -> void:
	_player = player
	_body = body

func _process(delta : float) -> void:
	_dash_timeout = max(0, _dash_timeout - delta)

func _physics_process(delta : float) -> void:
	# aim body to camera
	var delta_angle = body_target.angle() - _body.rotation
	if abs(delta_angle) > PI:
		delta_angle = delta_angle - sign(delta_angle) * 2 * PI
	_body.rotation += lerp(0.0, delta_angle, body_rotate_acceleration * delta)
	
	if _state == MOVING:
		_movement = lerp(_movement, movement_target, acceleration * delta)
		_player.set_velocity(_movement)
		_player.move_and_slide()
	elif _state == DASHING:
		var new_curve_position = min(1, _dash_curve_position + delta / _dash_time)
		var new_distance := dash_curve.sample(new_curve_position)
		var last_distance := dash_curve.sample(_dash_curve_position)
		_dash_curve_position = new_curve_position
		var delta_normalized := new_distance - last_distance

		var has_hit = _player.move_and_collide(_dash_direction * delta_normalized * _dash_dist)
		if has_hit || new_curve_position == 1:
			change_state(MOVING)

func run_direction(direction : Vector2) -> void:
	movement_target = direction.normalized() * speed

func get_velocity() -> float:
	return _movement.length()

func stop() -> void:
	change_state(IDLE)

func change_state(new_state) -> void:
	_state = new_state
	state_change.emit(_state)

func body_look_at(point : Vector2) -> void:
	body_target = point - _player.position

func can_dash_get() -> bool:
	return _dash_timeout <= 0

func dash(_direction : Vector2, time := dash_time, dist_multiplier : float = 1) -> void:
	_dash_direction = _direction
	_dash_time = time
	_dash_curve_position = 0
	_dash_timeout = dash_timeout
	_dash_dist = dash_dist * dist_multiplier
	change_state(DASHING)
