extends Area2D

class_name GrapplingHook

signal done
signal drop_body

# The distance of the CENTER of the body to the player
# TODO: update this automatically using raycasts
@export var shield_dist : float = 20

@onready var collider : CollisionShape2D = $Area3D
@onready var idle_position : Node2D = $IdlePosition
@onready var line : Line2D = $Line2D
@onready var _state_machine : StateMachine = $StateMachine

var _grappled_actor : Actor

# this is used rather then checking _grappled_body so that it updates instantly on drop_body() and not on
# the deferred call
var grappled_actor : Actor: get = get_grappled_actor
var has_actor : bool: get = get_has_actor
var _has_actor := false

func set_collider_disabled(value : bool) -> void:
	collider.set_deferred("disabled", value)

func attack() -> void:
	_state_machine.change_to("Attacking")

func mace() -> void:
	_state_machine.change_to("Macing")

func _on_Body_death() -> void:
	# drop body and if shielding change state
	if _has_actor:
		drop_actor()
	if _state_machine.state.name == "Shield":
		_state_machine.change_to("Idle")

func grab_actor(actor : Actor) -> void:
	assert(actor)
	actor.be_grappled()
	_grappled_actor = actor
	_has_actor = true
	actor.connect("death", Callable(self, "_on_Body_death"))

func drop_actor() -> void:
	_has_actor = false
	_grappled_actor.disconnect("death", Callable(self, "_on_Body_death"))
	_grappled_actor.be_ungrappled()
	_grappled_actor = null
	drop_body.emit()

func get_has_actor() -> bool:
	return _has_actor

func get_grappled_actor() -> Actor:
	if _has_actor:
		return _grappled_actor
	else:
		# We still have a reference to the actor but it will get dropped asap
		return null

func move_actor_to(pos : Vector2, delta : float) -> Vector2:
	# tries to move actor to relative position and returns delta between goal move and actual move
	if not delta || not _grappled_actor: return Vector2.INF
	var goal_pos := pos
	_grappled_actor.set_velocity((goal_pos - _grappled_actor.position) / delta)
	_grappled_actor.move_and_slide()
	return _grappled_actor.position - goal_pos

func fix_to_collider() -> void:
	if not _grappled_actor: return
	var delta_vector = _grappled_actor.global_position - global_position
	rotation = delta_vector.angle()
	collider.position = Vector2.RIGHT * delta_vector.length()
