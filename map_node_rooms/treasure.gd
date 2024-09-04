extends Control


func _ready():
	pass

func _on_exit_pressed():
	Events.treasure_scene_exited.emit()
