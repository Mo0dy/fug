extends Node

class_name SkillManager

@onready var player := owner

func enable_dash() -> void:
	owner.has_dash = true

func enable_hook() -> void:
	owner.has_hook = true
