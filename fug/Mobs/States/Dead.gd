extends MobState

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	if mob.animator.animation != "Death":
		mob.play_animation("Death")
		mob.animator.rotate(PI)
	mob.set_collider_disabled(true)
	mob.animator.z_index = -20
	mob.hit_audio.play()
	
	_callback(self._stop_play, 1)
	_callback(self._set_death_colors, 1)

func _stop_play() -> void:
	mob.hit_audio.stop()

func _set_death_colors() -> void:
	mob.animator.modulate = Color(0.75, 0.75, 0.125, 1)
