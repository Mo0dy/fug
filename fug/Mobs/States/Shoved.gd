extends MobState

@export var friction : float = 600
@export var hit_velocity_loss : float = 10
@export var min_kill_velocity = 200

var _speed : Vector2

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	mob.animator.rotate(PI)
	mob.play_animation("Death")
	# disable collision with other mobs
	# Don't do deferred otherwise they can collide with mobs in the first frame of movement
	mob.set_collision_layer_value(2, 0)
	mob.set_collision_mask_value(2, 0)
	mob.set_collision_mask_value(1, 0)
	mob.set_collision_layer_value(1, 0)
	
	mob.shove_collider.set_deferred("disabled", false)
	mob.audio.play()

func init_shove(direction : Vector2, shove_strength : float) -> void:
	_speed = direction.normalized() * shove_strength

func leave() -> void:
	super.leave()
	mob.shove_collider.set_deferred("disabled", true)

func physics_process(delta : float) -> void:
	var new_velocity = _decrease_velocity(friction * delta)
	if !mob._collider.disabled && new_velocity < min_kill_velocity:
		mob.shove_collider.set_deferred("disabled", true)
	if new_velocity == 0:
		_end_shove()
		return
	if mob.move_and_collide(delta * _speed):
		_end_shove()

func _decrease_velocity(amount : float):
	# returns the new velocity
	if amount > _speed.length():
		_speed = Vector2.ZERO
		return 0
	_speed -= _speed.normalized() * amount
	return _speed.length()

func _end_shove() -> void:
	controller.change_to("Dead")

func _on_ShoveArea_body_entered(body: Node) -> void:
	if body != mob && body.has_method("hit"):
		body.hit()
		_decrease_velocity(hit_velocity_loss)
