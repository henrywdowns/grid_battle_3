extends Node

var current_enemies = {} # key is instance; value is list containing instance and coords
func spawn_enemy(enemy_choice,scene,gridpoint:Marker2D):
	print("=== DEBUG: SPAWN_ENEMY ===")
	var enemy := load("res://enemies/%s.tscn" % enemy_choice) #load character scene based on selection
	var enemy_inst = enemy.instantiate()
	### STAT AND DECK SETUP ###
	#for key in balance_sheet.player_stats[selected_character]["stats"].keys(): # look at player_stats dict, selected character sub-dict, stats sub-sub-dict and iterate through stat keys
		#current_stats[key] = balance_sheet.player_stats[selected_character]["stats"][key]
	enemy_inst.position = gridpoint.global_position #take passed starting point position and put the character there
	enemy_inst.gridpoint = gridpoint
	scene.add_child(enemy_inst) #add the character to the tree calling the function
	#current_enemies[enemy_inst] = [enemy_inst,Global.translate_points_to_coords(gridpoint)]
	current_enemies[enemy_inst] = Global.translate_points_to_coords(gridpoint)
	enemy_inst.add_to_group("Enemies")
	print("    Current Enemies: ",current_enemies)
	print("=== END SPAWN_ENEMY ===")
	return enemy_inst
	
func spawn_random_enemy(scene):
	var enemy = random_enemy_name()
	print("Random enemy: ",enemy)
	spawn_enemy(enemy,scene,Global.random_panel("gridpoint"))

func killed_enemy(enemy: Node2D):
	current_enemies.erase(enemy)
	enemy.queue_free()
	print("Current enemies: ",current_enemies)

func test_spawn(scene,loc):
	spawn_enemy("test_enemy_1",scene,loc)

func enemy_hit(enemy:Node2D=null,dmg_value:int=0,on_hit_effect=null): #handle when enemy is hit
	print("=== DEBUG: ENEMY_HIT ===")
	var enemy_HP = enemy.enemy_stats["HP"] #let's just make this easy to type and read
	if enemy and (dmg_value or on_hit_effect): # make sure theres a valid target and attack
		print("enemy ",enemy," was hit for ",dmg_value," damage!") 
		print("Enemy HP: ",enemy_HP)
		if enemy_HP >= dmg_value:
			print("Enemy HP >= dmg_value")
			enemy_HP -= dmg_value
		else:
			print("Enemy HP < dmg_value")
			enemy_HP = 0
		print("New enemy HP: ",enemy_HP)
		update_health(enemy,enemy_HP)
	print("=== END ENEMY_HIT ===")

func update_health(enemy,new_HP):
	enemy.enemy_stats["HP"] = new_HP
	enemy.get_node("HitPoints").text = str(enemy.enemy_stats["HP"])
	if new_HP == 0:
		killed_enemy(enemy)

func clear_enemies():
	for enemy in current_enemies:
		enemy.queue_free()
	current_enemies = {}

func random_enemy_name():
	var balance_sheet = Global.check_balance_sheet()
	var random_enemy = balance_sheet.all_enemies.keys()[randi_range(0,len(balance_sheet.all_enemies)-1)]
	print(random_enemy)
	return random_enemy
