extends Node

class_name BasicMobMC

@export var enabled := true
@export var do_movement := true
@export var do_speed_lerp := true
@export var do_rotation := true
@export var do_rotation_lerp := true
@export var look_at_move : bool = false

@export var do_slide := true

@export var speed_control_tension : float = 20
@export var rotational_tension : float = 20

@export var friction : float = 0
@export var target_speed := Vector2.ZERO
@export var target_look := Vector2.RIGHT

enum Mode {CONTROL, FRICTION, NONE}

@export var mode := Mode.CONTROL

# the current speed of the controller
var speed := Vector2.ZERO: get = speed_get

var has_collided := false
var has_collided_last_update := false

@onready var _target : CharacterBody2D = owner as CharacterBody2D

func _physics_process(delta: float) -> void:
	if look_at_move && target_speed.length() > 0:
		target_look = target_speed
	if do_rotation:
		_rotate(delta)
	if do_movement:
		_move(delta)

func _rotate(delta : float) -> void:
	var delta_angle = target_look.angle() - _target.rotation
	if abs(delta_angle) > PI:
		delta_angle = delta_angle - sign(delta_angle) * 2 * PI
	if do_rotation_lerp:
		# HACK: don't use delta here. use proper formula or curve
		delta_angle = lerp(0.0, delta_angle, speed_control_tension * delta)
	_target.rotation += delta_angle

func _move(delta : float) -> void:
	if mode == Mode.CONTROL:
		if do_speed_lerp:
			speed = lerp(speed, target_speed, delta * speed_control_tension)
		else:
			speed = target_speed
	elif mode == Mode.FRICTION && friction:
		slowdown(friction * delta)

	has_collided_last_update = has_collided
	if do_slide:
		_target.set_velocity(speed)
		_target.move_and_slide()
		has_collided = _target.velocity != speed
	else:
		has_collided = _target.move_and_collide(speed * delta) != null

func slowdown(amount : float) -> void:
	if amount > speed.length():
		speed = Vector2.ZERO
	speed -= speed.normalized() * amount

func get_velocity() -> float:
	return speed.length()

func speed_get() -> Vector2:
	return speed

func stop() -> void:
	target_speed = Vector2.ZERO
