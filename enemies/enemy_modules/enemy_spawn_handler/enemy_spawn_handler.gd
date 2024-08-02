extends Node

func _ready():
	print("	### ENEMY SPAWN HANDLER ###")
	print(get_parent())
	print("	### END ENEMY SPAWN HANDLER ###")


### THIS DOESNT WORK SO GOOD YET... ###
func spawn_enemy(loc,intended_enemy,calling_scene = null):
	var enemy_node = get_parent()
	enemy_node.generate_enemy(intended_enemy)
	enemy_node.global_position = loc.global_position
	# scene.add_child(enemy_node)
	return enemy_node
