extends TextureRect

var first_level: PackedScene = preload("res://Levels/Main.tscn")

func _on_New_Game_pressed():
	GameManager.scene_changer.change_scene(first_level)
	pass
