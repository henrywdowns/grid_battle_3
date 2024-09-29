extends Control

@onready var accepting_input = false
var player_char: Node2D
var current_enemies = []

func _ready():
	print_debug("### BATTLE SCENE ###")
	build_stage()
	#await Events.stop_awaiting
	#print_debug("stop_awaiting received")
	ready_char()
	ready_enemy()
	card_ui_init()
	Global.battle_node = $"."
	#Events.i_died.connect(check_if_all_dead)

func _process(_delta):
	pass

### BATTLE SCENE CONSTRUCTION AND CONTROLS ###

var gridpoints = []
var panels = []
var starting_point: Marker2D
var enemy_starting_point: Marker2D #for testing. plan for automatically generated start points down the line
var panel_status = {}
# 

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
	Global.battle_gridpoints = gridpoints
	Global.battle_grid_coords = grid_coords
	for panel in $"Arena Panels".get_children():
		#this works its way down vertically left horizontally. ie x0y1 -> x0y2 -> x1y0
		panels.append(panel)
		gridpoints.append(panel.get_children()[0])
		panel_status[panel] = {
			"status":"normal", # for terrain changes, normal by default
			"occupant":null # empty by default
		}
		panel_status[panel]["panel_id"] = x
		if x < 9: 
			panel_status[panel]["color"] = "blue" # first 9 panels are player panels
			Global.player_panels.append(panel)
		else:
			panel_status[panel]["color"] = "red" # last 9 are enemy panels
			Global.enemy_panels.append(panel.get_node("Marker2D"))
		x += 1
		panel_status[panel]["panel_coords"] = Vector2(int(String(panel.name)[1]),int(String(panel.name)[3])) # vector2 of panel_coords for easy reference
		panel_status[panel]["panel_gridpoint"] = Global.translate_coords_to_points(panel_status[panel]["panel_coords"])
	starting_point = gridpoints[4]
	print_debug("Panel status: ",panel_status)
	print_debug(Global.battle_points_to_panels)
	for panel in panel_status.keys():
		Global.battle_points_to_panels[panel_status[panel]["panel_gridpoint"]] = panel
	print(Global.battle_points_to_panels)
	Events.call_deferred("emit_signal", "stop_awaiting")
	Events.entity_moved.connect(update_panel_status)
	print_debug("stop awaiting emitted")
	


func update_panel_status(entity, old_panel:Sprite2D=null, new_panel:Sprite2D=null):
	print("Entity:", entity)
	print("Old Panel:", old_panel, "Type:", typeof(old_panel))  # Print type and value of old_panel
	print("New Panel:", new_panel, "Type:", typeof(new_panel))  # Print type and value of new_panel
	
	# Check if old_panel and new_panel are either null or Sprite2D
	if old_panel != null and !(old_panel is Sprite2D):
		print("Error: old_panel is not a Sprite2D!")
		return
	if new_panel != null and !(new_panel is Sprite2D):
		print("Error: new_panel is not a Sprite2D!")
		return

	# Proceed with logic if everything is valid
	var _occupant = panel_status[old_panel]["occupant"]
	panel_status[old_panel]["occupant"] = null
	panel_status[new_panel]["occupant"] = _occupant


### BATTLE-SPECIFIC CHARACTER MANAGEMENT ###
# Incl. Spawning & Stats

var current_stats: Dictionary
var current_deck: Array
var enemy_dict = {} ### THIS IS NOT BEING UPDATED WHEN ENEMIES DIE

func ready_char():
	Events.emit_node.connect(pass_gridpoints)
	player_char = spawn_player(self)
	Events.stop_awaiting.emit()

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
	#current_enemies.append(spawn_enemy(self,gridpoints[16],"test_enemy_2"))
	#var temp_panel_2 = Array(panel_status.keys())[16]
	panel_status[temp_panel]['occupant']=Array(enemy_dict.keys())[0]
	#panel_status[temp_panel_2]['occupant']=Array(enemy_dict.keys())[1]
	Events.i_died.connect(clean_up_enemy)
	Events.stop_awaiting.emit()

func spawn_enemy(scene,loc,intended_enemy) -> Node2D:
	var enemy := load("res://enemies/base_enemy.tscn")
	var enemy_node = enemy.instantiate()
	enemy_node.generate_enemy(intended_enemy)
	enemy_node.global_position = loc.global_position
	enemy_node.enemy_coords = Global.translate_points_to_coords(loc)
	scene.add_child(enemy_node)
	enemy_dict[enemy_node] = enemy_node.enemy_hp
	#panel_status[loc]["occupant"]=enemy_node
	return enemy_node

func clean_up_enemy(target_enemy:BaseEnemy):
	enemy_dict.erase(target_enemy)
	check_if_all_dead()
	for panel in panel_status:
		if panel_status[panel]["occupant"] == target_enemy:
			panel_status[panel]["occupant"] = null
			return
			
	print_debug("Error -- enemy not found")


### YOU WIN ###

func you_win():
	print_debug("### You Win ###")
	Global.battle_node = null
	Events.you_win.emit()
	#$"PickACard".run_draft()
	await Events.card_chosen
	#Global.progress_map()
	#Global.goto_scene("res://scenes/map.tscn")

func check_if_all_dead():
	print_debug("checking if they're all dead...")
	var enemies_left = len(Array(enemy_dict.keys()))
	print_debug("Number of enemies: ",enemies_left)
	if enemies_left <= 0:
		print("none left")
		you_win()

func _on_button_pressed():
	you_win()

### CARD UI HANDLING ### 
func card_ui_init():
	$CardUI.visible = true # this way i can hide the node in the 2D editing screen
	$CardUI.player_hand_node = get_node("Character1/PlayerHand")
