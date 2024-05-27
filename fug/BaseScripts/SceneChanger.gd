extends Node

class_name SceneChanger

signal scene_changed()

var menu_scene: PackedScene = preload("res://UI/MainMenu.tscn")

func change_scene(scene: PackedScene, delay : float = 0) -> void:
	await get_tree().create_timer(delay).timeout
	get_tree().change_scene_to_packed(scene)

func change_to_main_menu(delay : float = 0) -> void:
	await change_scene(menu_scene, delay)
