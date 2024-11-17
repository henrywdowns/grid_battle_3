extends CardEffect
class_name ProjectileGenerator

### Arguments Array Requirements:
	# Projectile tres

func trigger_effect(arguments: Array,wildcard_dict: Dictionary={}) -> void:
	print("*~*~*~*~*~*~*~*~ Projectile attempt ~*~*~*~*~*~*~*~*")
	var battle_node = Global.battle_node
	var base_projectile = load("res://projectiles/base_projectile.tscn")
	var player_character = battle_node.get_node("Character1")
	var player_gridpoint = player_character.character_gridpoint
	print_debug("Targets -- ",arguments," -- Dict values -- ",wildcard_dict)
	for arg in arguments:
		#print_debug("Currently targeting -- ",arg)
		if arg is Projectile: #TODO: Once Enemies are properly classed, change Node2D to Enemy
			var projectile_inst = base_projectile.instantiate()
			projectile_inst.projectile_resource = arg
			projectile_inst.set_stats()
			projectile_inst.projectile_gridpoint = player_gridpoint+Vector2(1,0)
			print_debug("Projectile_gridpoint = ",projectile_inst.projectile_gridpoint)
			projectile_inst.projectile_coords = Global.translate_points_to_coords(projectile_inst.projectile_gridpoint)
			print_debug("Projectile coords = ",projectile_inst.projectile_coords)
			projectile_inst.global_position = projectile_inst.projectile_gridpoint.global_position
			battle_node.add_child(projectile_inst)
			
		else:
			print_debug("Damage Assignment Error -- incorrect target or wildcard type")
