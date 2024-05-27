extends State

class_name BasicMobStateDeath

@onready var _mob : BasicMob = owner as BasicMob

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	_mob.movement_controller.target_speed = Vector2.ZERO
	if _mob.animator.animation != "Death":
		_mob.play_animation("Death")
		_mob.animator.rotate(PI)
	_mob.animator.z_index = -20
	_mob.death_audio.play()
	
	_callback(self._stop_play, 1)
	_callback(self._set_death_colors, 1)

func _stop_play() -> void:
	_mob.death_audio.stop()

func _set_death_colors() -> void:
	_mob.animator.modulate = Color(0.75, 0.75, 0.125, 1)

