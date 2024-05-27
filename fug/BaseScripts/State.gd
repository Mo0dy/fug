extends Node

class_name State

var controller : StateMachine
var _callbacks = []
var is_active := false

func enter(controller_: StateMachine) -> void:
	controller = controller_
	is_active = true
	
func leave() -> void:
	is_active = false
	_callbacks = []

func change_to(target_state : String) -> void:
	controller.change_to(target_state)

func process(delta : float) -> void:
	var to_remove = []
	for c in _callbacks:
		if c.update(delta):
			to_remove.append(c)
	for c in to_remove:
		_callbacks.erase(c)

func _callback(callback : Callable, time : float, arguments : Array=[]) -> void:
	# adds timed callback function to this state that will be revoked by
	# enter()
	self._callbacks.append(Callback.new(time, callback, arguments))

class Callback:
	# Used to do timings that can be cleared again
	# Opposed to coroutines
	var _end_time : float
	var _callback : Callable
	var _arguments : Array
	var _time : float = 0
	
	func _init(time : float, callback : Callable, arguments : Array) -> void:
		_end_time = time
		_callback = callback
		_arguments = arguments
	
	func update(delta : float) -> bool:
		_time += delta
		if _time >= _end_time:
			_callback.callv(_arguments)
			return true
		return false
