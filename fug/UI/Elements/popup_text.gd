extends Control

class_name PopupText

@onready var label : Label = $Label
@onready var animation : AnimationPlayer = $Label/AnimationPlayer

func _ready() -> void:
	# set the label material uniform "size" to the size of the label
	label.material.set_shader_parameter("size", label.size)

func display_text(text: String, duration: float) -> void:
	label.text = text
	animation.speed_scale = 1.0 / duration
	animation.play("fade_in_animation")
