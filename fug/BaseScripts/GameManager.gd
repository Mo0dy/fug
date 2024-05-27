extends Node

@export var disable_slowdown := false
@export var slowdown_curve : Curve
@export var slowdown_time : float = 0.3

# SINGLETON

# The level mananger will register himself here
var level_manager : LevelManager
var player : Player: get = get_player

var _last_speed : float = 1

var _slowdown_animation : AnimatedCurve
var _doing_animation := false

@onready var scene_changer : SceneChanger = $SceneChanger

func _process(delta: float) -> void:
	if _doing_animation:
		if Engine.time_scale == 0: return
		_doing_animation = not _slowdown_animation.update(delta / Engine.time_scale)
		Engine.time_scale = _slowdown_animation.value
		

func get_player() -> Player:
	return level_manager.player

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_F:
				get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
			elif event.keycode == KEY_R:
				if Engine.time_scale == 1:
					Engine.time_scale = 0.1
				else:
					Engine.time_scale = 1
			elif event.keycode == KEY_P:
				if Engine.time_scale == 0:
					Engine.time_scale = _last_speed
				else:
					_last_speed = Engine.time_scale
					Engine.time_scale = 0

func slowdown(time := slowdown_time) -> void:
	if disable_slowdown: return
	_slowdown_animation = AnimatedCurve.new(slowdown_curve, time)
	_doing_animation = true
	# also do shake
	var camera := level_manager.player.get_node("CameraFollower/Camera2D")
	if camera && camera.has_method("shake"):
		camera.shake(0.3, 17, 8)

func debug_pos(pos : Vector2) -> void:
	level_manager.debug_node.position = pos
