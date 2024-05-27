extends State

@export var sweep := -PI
@export var sweep_time : float = 0.2
@export var windup_time : float = 0.2

var _attacking := false

@onready var _sword : Sword = owner as Sword

func enter(collider_ : StateMachine) -> void:
	super.enter(collider_)
	_attacking = false
	_callback(self._start_attack, windup_time)
	_audio_effect()

func leave() -> void:
	super.leave()
	_sword.collider_attack.set_deferred("disabled", true)
	if _sword.hit_area.is_connected("body_entered", Callable(self, "_on_HitArea_body_entered")):
		_sword.hit_area.disconnect("body_entered", Callable(self, "_on_HitArea_body_entered"))
	_sword.attack_done()

func _start_attack() -> void:
	_sword.collider_attack.rotation = 0
	_sword.collider_attack.set_deferred("disabled", false)
	_sword.hit_area.connect("body_entered", Callable(self, "_on_HitArea_body_entered"))
	_attacking = true

func physics_process(delta: float) -> void:
	if not _attacking: return
	# TODO: move to animator
	_sword.collider_attack.rotation += sweep / sweep_time * delta
	if abs(_sword.collider_attack.rotation) > abs(sweep):
		_sword.collider_attack.rotation = sweep
		controller.change_to("Default")

func _on_HitArea_body_entered(body : Actor) -> void:
	# HACK: avoid double hit if the collision layer is changed during physics
	if not body: return
	if not body.collision_layer: return
	_sword.on_hit(body)

func _audio_effect() -> void:
	_sword.attack_audio.play()
	# HACK: just use a better track:
	await get_tree().create_timer(0.2).timeout
	_sword.attack_audio.stop()
