extends State

@onready var imp : Imp = owner
var target = null
const SPEED = 300

func physics_process(delta):
	if target:
		var player := GameManager.player
		#var velocity = player.direction_to(target.player)
		#imp.move_and_collide(velocity * SPEED * delta)


func _on_Area2D_body_entered(body):
	target = body


func _on_Area2D_body_exited(body):
	target = null
