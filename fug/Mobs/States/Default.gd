extends MobState

@export var speed : float = 70
@export var target_distance : float = 800

func enter(controller_: StateMachine) -> void:
	super.enter(controller_)
	mob.animator.play("Walk")

func process(delta : float) -> void:
	super.process(delta)
	var player := GameManager.player
	var dist = (player.position - owner.position).length()
	if dist < target_distance:
		controller.change_to("Target")

func physics_process(delta: float) -> void:
	# just move forward  . . .		
	owner.set_velocity(Vector2.RIGHT.rotated(owner.rotation) * speed)
	owner.move_and_slide()
	owner.velocity
	
