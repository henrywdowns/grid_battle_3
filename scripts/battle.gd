extends Control

@onready var accepting_input = false
var player_char: Node2D
var current_enemies = []

func _ready():
	print_debug("### BATTLE SCENE ###")
	build_stage()
	ready_char()
	ready_enemy()
	card_ui_init()
	#Events.i_died.connect(check_if_all_dead)

func _process(_delta):
	pass

### BATTLE SCENE CONSTRUCTION AND CONTROLS ###

var gridpoints = []
var panels = []
var starting_point: Marker2D
var enemy_starting_point: Marker2D #for testing. plan for automatically generated start points down the line
var panel_status = {}

var grid_coords = [
	Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
	Vector2(2, 0), Vector2(2, 1), Vector2(2, 2),
	Vector2(3, 0), Vector2(3, 1), Vector2(3, 2),
	Vector2(4, 0), Vector2(4, 1), Vector2(4, 2),
	Vector2(5, 0), Vector2(5, 1), Vector2(5, 2)
	]

var grid_partition = 2	#represents furthest right player can go. want to declare
					   #so in the future i can adjust with effects

func build_stage():
	var x = 0
	for panel in $"Arena Panels".get_children():
		#this works its way down vertically left horizontally. ie x0y1 -> x0y2 -> x1y0
		panels.append(panel)
		gridpoints.append(panel.get_children()[0])
		panel_status[panel] = {
			"status":"normal",
			"occupant":null
		}
		panel_status[panel]["panel_id"] = x
		if x < 9: 
			panel_status[panel]["color"] = "blue"
		else:
			panel_status[panel]["color"] = "red"
	starting_point = gridpoints[4]
	
func update_panel_status(new_panel=null,old_panel=null):
	#TODO: WHEN READY - CONNECT EVENTS.ENTITY_MOVED(UPDATE_PANEL_STATUS)
	pass

### BATTLE-SPECIFIC CHARACTER MANAGEMENT ###
# Incl. Spawning & Stats

var current_stats: Dictionary
var current_deck: Array
var enemy_dict = {} ### THIS IS NOT BEING UPDATED WHEN ENEMIES DIE

func ready_char():
	Events.emit_node.connect(pass_gridpoints)
	player_char = spawn_player(self)

func spawn_player(scene,loc: Marker2D=starting_point) -> Node2D:
	var new_character := load("characters/base_character.tscn") #load character scene based on selection
	var player_char_node = new_character.instantiate()
	### STAT AND DECK SETUP ###
	current_stats = Global.meta_character_stats #transfer persistent stats to battle
	current_deck = Deck.meta_deck #transfer persistent deck to battle
	### END SETUP ###
	player_char_node.position = loc.global_position #take passed starting point position and put the character there
	scene.add_child(player_char_node) #add the character to the tree calling the function
	player_char_node.add_to_group("Player")
	return player_char_node #returns the player_char_node as a value that can be referenced in script calling this func

func pass_gridpoints(dest_node,spawning=true):
	dest_node.gridpoints = gridpoints
	dest_node.grid_partition = grid_partition
	if !spawning:
		pass
	else:
		dest_node.player_current_panel = Vector2(1,1)

### ENEMY HANDLING ###
func ready_enemy():
	current_enemies.append(spawn_enemy(self,gridpoints[13],"test_enemy_1"))
	var temp_panel = Array(panel_status.keys())[13]
	current_enemies.append(spawn_enemy(self,gridpoints[16],"test_enemy_2"))
	var temp_panel_2 = Array(panel_status.keys())[16]
	panel_status[temp_panel]['occupant']=Array(enemy_dict.keys())[0]
	panel_status[temp_panel_2]['occupant']=Array(enemy_dict.keys())[1]
	Events.i_died.connect(clean_up_enemy)

func spawn_enemy(scene,loc,intended_enemy) -> Node2D:
	var enemy := load("res://enemies/base_enemy.tscn")
	var enemy_node = enemy.instantiate()
	enemy_node.generate_enemy(intended_enemy)
	enemy_node.global_position = loc.global_position
	scene.add_child(enemy_node)
	enemy_dict[enemy_node] = enemy_node.enemy_hp
	print_debug("New enemy spawned. Dict updated -- %s" % enemy_dict)
	#panel_status[loc]["occupant"]=enemy_node
	return enemy_node

func clean_up_enemy(target_enemy):
	print_debug("CLEANING UP ",target_enemy)
	print_debug(panel_status)
	print_debug(enemy_dict)
	print_debug(enemy_dict.erase(target_enemy))
	print_debug(enemy_dict)
	check_if_all_dead()
	for panel in panel_status:
		if panel_status[panel]["occupant"] == target_enemy:
			print_debug("Panel -- ", panel_status[panel])
			print_debug("Cleaning up enemy %s" % target_enemy)
			panel_status[panel]["occupant"] = null
			print_debug("Panel after cleanup -- ",panel_status[panel])
			return
			
	print_debug("Error -- enemy not found")


### YOU WIN ###

func you_win():
	print_debug("### You Win ###")
	Events.you_win.emit()
	$"PickACard".run_draft()
	await Events.card_chosen
	Global.progress_map()
	Global.goto_scene("res://scenes/map.tscn")

func check_if_all_dead():
	var enemies_left = len(Array(enemy_dict.keys()))
	print_debug("Number of enemies: ",enemies_left)
	if enemies_left <= 0:
		you_win()

func _on_button_pressed():
	you_win()

### CARD UI HANDLING ### 
func card_ui_init():
	$CardUI.visible = true # this way i can hide the node in the 2D editing screen
	$CardUI.player_hand_node = get_node("Character1/PlayerHand")
