extends State

export var shove_strength : float = 400

onready var _sword : NewSword = owner as NewSword

func enter(collider_ : StateMachine) -> void:
	.enter(collider_)
	_audio_effect()
	_sword.collider_shove.set_deferred("disabled", false)
	_sword.hit_area.connect("body_entered", self, "_on_HitArea_body_entered")

func leave() -> void:
	.leave()
	_sword.collider_shove.set_deferred("disabled", true)
	_sword.hit_area.disconnect("body_entered", self, "_on_HitArea_body_entered")
	_sword.attack_done()

func _on_HitArea_body_entered(body : Actor) -> void:
	if not body: return
	_sword.on_hit(body)

func _audio_effect() -> void:
	_sword.attack_audio.play()
	# HACK: just use a better track:
	yield(get_tree().create_timer(0.2), "timeout")
	_sword.attack_audio.stop()
