extends Node


@onready var map: Map = $Map
@onready var char_select: Control = $CharSelect


func _ready() -> void:
	pass
	
func _lets_make_it_happen() -> void:
	map.generate_new_map()
	map.unlock_floor(0)

func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	map.show_map()
	map.unlock_next_rooms()
