extends Node

var current_position = Vector2(1,1)
var selected_character = null

func set_meta_stats(): #for when character is initially selected - pull from balance sheet and create persistent stats and deck
	var balance_sheet = Global.check_balance_sheet()
	for key in balance_sheet.player_stats[selected_character]["stats"].keys(): # look at player_stats dict, selected character sub-dict, stats sub-sub-dict and iterate through stat keys
		meta_current_stats[key] = balance_sheet.player_stats[selected_character]["stats"][key]
	for card in balance_sheet.player_stats[selected_character]["starting_deck"]:
		meta_current_deck.append(card)
	print("Meta stats updated. Character: %s - Stats: %s - Deck: %s" % [selected_character,meta_current_stats,meta_current_deck])

func spawn_player(scene,loc: Marker2D) -> Node2D:
	print(get_tree().current_scene)
	var character := load("res://characters/%s.tscn" % selected_character) #load character scene based on selection
	var player_char = character.instantiate()
	### STAT AND DECK SETUP ###
	#for key in balance_sheet.player_stats[selected_character]["stats"].keys(): # look at player_stats dict, selected character sub-dict, stats sub-sub-dict and iterate through stat keys
		#current_stats[key] = balance_sheet.player_stats[selected_character]["stats"][key]
	current_stats = meta_current_stats #transfer persistent stats to battle
	current_deck = meta_current_deck #transfer persistent deck to battle
	### END SETUP ###
	player_char.position = loc.global_position #take passed starting point position and put the character there
	scene.add_child(player_char) #add the character to the tree calling the function
	print("Current stats from singleton: ",current_stats)
	print("Current deck from singleton: ",current_deck)
	player_char.add_to_group("Player")
	print("    ---- Tree: ",get_tree().get_nodes_in_group("Player"))
	return player_char #returns the player_char node as a value that can be referenced in script calling this func
	
func cleanup():
	current_position = Vector2(1,1) #placeholder in case there are things that need to go away at the *end* of battle or aren't handled by spawn_player()
	current_stats = meta_current_stats
	current_deck = meta_current_deck

# below are in-game character and deck info. these should be updated and persist through one playthrough.
# TODO: make a func that updates below with figures from Balance_Sheet.gd. also, decide if it goes here or where new games are triggered
var meta_current_stats = {"HP":1,"basic_attack":0,"move_delay":0} #this one persists through the run, reflects permanent boosts, etc
var current_stats = {"HP":1,"basic_attack":0,"move_delay":0} #this one changes in battle and resets at the end. here is where temporary changes get made.
var meta_current_deck = [] #holds the cards outside of battle. informs current_deck when battle starts. 
var current_deck = [] # pulls a list from Balance_sheet.gd. TODO: create func to pull assets for cards using cardnames. maybe i also instantiate 
					  # card abilities through it to save memory?
var current_artifacts = [] #saving space for this too. presumably there will be persistent effects like StS relics, and they need to live somewhere
var current_loc_on_map = "" #just saving space for this. i don't know what format it will take yet. need to build map functionality to know I think

### BATTLE FUNCTIONS ###

func hitscan_attack(piercing=false):
	print("=== DEBUG: HITSCAN_ATTACK ===")
	var enemies_in_row = []
	var closest_enemy = []
	for i in EnemyHandler.current_enemies.keys(): #run through all available enemies
		if is_instance_valid(i): # filter out freed instances. stupid that i have to do this.
			var i_coords = EnemyHandler.current_enemies[i] # location of iteration of current enemies
			if i_coords[1] == current_position[1]: # if current iteration shares y value add instance and loc to enemies in row
				print("    Current_position[1]: ",current_position[1])
				enemies_in_row.append([i,i_coords])
				print("    Found enemies in row: ",enemies_in_row)
	if enemies_in_row: # if we found anymies sharing y value, determine who gets hit
		if piercing: # some hitscan weapons may have piercing
			return enemies_in_row # gives all enemies and coordinates so the attack can call enemy_hit on all of them
		for enemy in enemies_in_row: # if no piercing, we move forward to determine who the closest enemy is by iterating through enemies_in_row for lowest x value
			if !closest_enemy:
				closest_enemy.append(enemy)
				closest_enemy.append(enemy[1])
			if enemy[1][0]<closest_enemy[1][0]:
				closest_enemy = enemy
		return closest_enemy[0] # return closest enemy and coordinates
		# reminder that the actual enemy instancee is closest_enemy[0] and EnemyHandler.enemy_hit handles damage
	else:
		print("    Missed")
		return ['']
	print("=== END HITSCAN ATTACK ===")

func basic_attack():
	print("=== DEBUG: BASIC HITSCAN ===")
	var target = hitscan_attack()[0]
	if !target:
		return
	print("    target: ",target)
	EnemyHandler.enemy_hit(target,int(current_stats["basic_attack"]))
	print("=== END BASIC HITSCAN ===")
