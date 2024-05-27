extends Curve

class_name AnimatedCurve

var _curve : Curve
var _total_time : float
var _max_value : float

var current_time : float
var value : float
var last_value : float

# var delta : float: get = delta_get

func _init(curve : Curve, time : float=1, scale : float=1) -> void:
	_curve = curve
	_total_time = time
	_max_value = scale
	reset()

func reset() -> void:
	current_time = 0
	last_value = 0
	value = 0

func update(delta : float) -> bool:
	# updates the curve by delta time. returns true if animation is finished
	# last_value = value

	# TODO: check this
	current_time = min(_total_time, current_time + delta)
	var normalized_time = current_time / _total_time
	value = _curve.sample(normalized_time) * _max_value
	return abs(normalized_time - 1) < 0.00001
 
# func delta_get() -> float:
# 	return value - last_value
