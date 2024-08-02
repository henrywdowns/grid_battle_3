extends Node2D

@onready var accepting_input = false
var player_char: Node2D
var current_enemies = []

func _ready():
	build_stage()
	print('Panel status: ',panel_status)
	ready_char()
	ready_enemy()

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

### BATTLE-SPECIFIC CHARACTER MANAGEMENT ###
# Incl. Spawning & Stats

var current_stats: Dictionary
var current_deck: Array
var enemy_dict = {}

func ready_char():
	Events.emit_node.connect(pass_gridpoints)
	player_char = spawn_player(self)

func spawn_player(scene,loc: Marker2D=starting_point) -> Node2D:
	var new_character := load("characters/%s.tscn" % Global.selected_character) #load character scene based on selection
	print(new_character)
	print("characters/%s.tscn" % Global.selected_character)
	var player_char_node = new_character.instantiate()
	### STAT AND DECK SETUP ###
	current_stats = Global.meta_character_stats #transfer persistent stats to battle
	current_deck = Deck.meta_deck #transfer persistent deck to battle
	### END SETUP ###
	player_char_node.position = loc.global_position #take passed starting point position and put the character there
	scene.add_child(player_char_node) #add the character to the tree calling the function
	print("Current stats from singleton: ",current_stats)
	print("Current deck from singleton: ",current_deck)
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
	current_enemies.append(spawn_enemy(self,gridpoints[13],"test_enemy_2"))
	var temp_panel = Array(panel_status.keys())[13]
	#print(temp_panel)
	panel_status[temp_panel]['occupant']=Array(enemy_dict.keys())[0]
	Events.i_died.connect(clean_up_enemy)

func spawn_enemy(scene,loc,intended_enemy) -> Node2D:
	var enemy := load("res://enemies/base_enemy.tscn")
	var enemy_node = enemy.instantiate()
	enemy_node.generate_enemy(intended_enemy)
	enemy_node.global_position = loc.global_position
	scene.add_child(enemy_node)
	enemy_dict[enemy_node] = enemy_node.enemy_hp
	print("New enemy spawned. Dict updated -- %s" % enemy_dict)
	#panel_status[loc]["occupant"]=enemy_node
	return enemy_node

func clean_up_enemy(enemy):
	for panel in panel_status:
		if panel_status[panel]["occupant"] == enemy:
			print("Cleaning up enemy %s" % enemy)
			panel_status[panel]["occupant"] = null
			return
			
	print("Error -- enemy not found")


### YOU WIN ###

func you_win():
	Global.progress_map()
	Global.goto_scene("res://scenes/map.tscn")

func _on_button_pressed():
	you_win()
