extends Node
signal spawn_handler

func _ready():
	print_debug("	### ENEMY SPAWN HANDLER ###")
	print_debug(get_parent())
	print_debug("	### END ENEMY SPAWN HANDLER ###")


### THIS DOESNT WORK SO GOOD YET... ###
func spawn_enemy(loc,intended_enemy,calling_scene = null):
	var enemy_node = get_parent() # save enemy node as variable
	spawn_handler.emit()
	enemy_node.generate_enemy(intended_enemy) # call 
	enemy_node.global_position = loc.global_position
	# scene.add_child(enemy_node)
	return enemy_node
