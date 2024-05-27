extends Actor

class_name Player

signal try_buy(player)

@onready var state_machine := $SMGrapplingHook
@onready var body := $Body
@onready var weapon : PlayerWeapon = $Body/Sword
@onready var animator := $Body/Animator
@onready var grappling_hook : GrapplingHook = $GrapplingHook
@onready var movement_controller : PlayerDefaultMC = $PlayerMovementController
@onready var skill_manager := $PlayerSkillManager

@onready var _collider := $CollisionShape2D

@export var has_dash := false;
# HACK: this should probably just be a change in statemachines?
@export var has_hook := false;

func _ready() -> void:
	movement_controller.init(self, body)

func die() -> void:
	super.die()
	state_machine.change_to("Death")

func play_animation(animation_name : String) -> void:
	animator.play(animation_name)

func set_collider_disabled(state : bool) -> void:
	_collider.set_deferred("disabled", state)

func get_player_rotation() -> float:
	return body.rotation

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("buy"):
		try_buy.emit(self)
