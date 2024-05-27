extends Actor

@onready var _animator := $Animator

func die() -> void:
	super.die()
	_animator.play("Death")

func shoved(_impulse : Vector2) -> void:
	die()
