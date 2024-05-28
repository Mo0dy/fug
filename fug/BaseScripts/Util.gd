class_name Util

const LAYER_ACTORS : int = 1
const LAYER_PLAYER : int = 2
const LAYER_WALLS : int = 4

# Utility funcitons

static func get_animation_time(animator : AnimatedSprite2D, animation : String) -> float:
	# Returns the total animation time for the currently selected animation
	var frames = animator.sprite_frames
	return  frames.get_frame_count(animation) \
			/ frames.get_animation_speed(animation) \
			/ animator.speed_scale
