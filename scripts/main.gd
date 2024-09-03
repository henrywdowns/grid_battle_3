extends Control

func _ready():
	pass
	#get_tree().paused = true

func _on_button_button_up():
	Global.goto_scene("res://scenes/char_select.tscn")
