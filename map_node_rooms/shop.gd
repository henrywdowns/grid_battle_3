extends Node

func _ready():
	pass
	


func _on_exit_pressed():
	Events.shop_exited.emit()
