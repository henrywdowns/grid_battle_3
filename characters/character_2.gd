extends Node2D

var stats: Dictionary = {"HP":120,"basic_attack":4,"move_delay":0.3}
var char_meta_data: Dictionary = {"Name":"Character 2","filename":"character_2"}
# Called when the node enters the scene tree for the first time.
@onready var current_health: int = stats.HP

func _ready() -> void:
	print_debug("Starting Health: %s" % stats.HP)
	print_debug("Basic Attack: %s" % stats.basic_attack)
	print_debug("Move Delay: %s" % stats.move_delay)

