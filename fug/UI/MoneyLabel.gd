extends Label

var _connected := false

func _process(_delta: float) -> void:
	# HACK!!!
	if _connected: return
	if GameManager.level_manager:
		GameManager.level_manager.connect("money_changed", Callable(self, "_on_LevelManager_money_changed"))
		text = str(GameManager.level_manager._money)
		_connected = true

func _on_LevelManager_money_changed(amount : int) -> void:
	text = str(amount)
