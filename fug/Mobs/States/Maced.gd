extends MobStateGrappled

func enter(controller_ : StateMachine) -> void:
	super.enter(controller_)
	
	mob.set_collision_layer_value(2, 0)
	mob.set_collision_mask_value(2, 0)
	mob.set_collision_mask_value(1, 0)
	mob.set_collision_layer_value(1, 0)
	
	mob.shove_collider.set_deferred("disabled", false)
	mob.audio.play()

func leave() -> void:
	super.leave()
	mob.shove_collider.set_deferred("disabled", true)

func _on_ShoveArea_body_entered(body: Node) -> void:
	if body != mob && body.has_method("hit"):
		body.hit()
