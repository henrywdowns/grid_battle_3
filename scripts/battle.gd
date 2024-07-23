extends Node2D

@onready var accepting_input = true
var player_char: Node2D

func _ready():
	build_stage()
	starting_point = gridpoints[4]
	player_char = spawn_player(self)
	player_current_panel = Vector2(1,1)

func _input(_event):
	if accepting_input == true:
		for direction in movement_directions:
			if Input.is_action_just_pressed(direction):
				move_char(direction)
	#put attacks here too once those are up

### BATTLE SCENE CONSTRUCTION AND CONTROLS ###

var gridpoints = []
var panels = []
var starting_point: Marker2D
var panel_status = {}

var grid_coords = [
	Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
	Vector2(2, 0), Vector2(2, 1), Vector2(2, 2),
	Vector2(3, 0), Vector2(3, 1), Vector2(3, 2),
	Vector2(4, 0), Vector2(4, 1), Vector2(4, 2),
	Vector2(5, 0), Vector2(5, 1), Vector2(5, 2)
	]

var grid_partition = 2 #represents furthest right player can go. want to declare
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

### CHARACTER MOVEMENT ###

### new attack plan:
#going to throw away the coordinate system (for collision at least)
#instead of doing the math every time to calculate a hit (which means lots of different logic
#depending on attacks, i'm going to make characters snap to marker2d like before, but they will
#have hitboxes that just confirm to the entire panel they're on. then attacks will similarly 
#launch projectiles with hitboxes oriented to the height of they panels they should be on, allowing
#for more seamless collision detection and tween movement from panel to panel. it's more flexible.

var movement_directions = ["Up","Down","Left","Right"]
var player_current_panel: Vector2

func move_char(dir):
	var movement_vars = {
		"Up":Vector2(0,-1),
		"Down":Vector2(0,1),
		"Left":Vector2(-1,0),
		"Right":Vector2(1,0)
	}
	var temp_target_panel: Vector2 = player_current_panel + movement_vars[dir]
	print("Target panel: %s" % temp_target_panel)
	if temp_target_panel[0] > -1 && temp_target_panel[0] <= grid_partition && temp_target_panel[1] > -1 && temp_target_panel[1] < 3:
		var target_panel = temp_target_panel
		var target_panel_index = grid_coords.find(target_panel)
		player_current_panel = target_panel
		player_char.global_position = gridpoints[target_panel_index].global_position
	

### BATTLE-SPECIFIC CHARACTER MANAGEMENT ###
# Incl. Spawning & Stats

var current_stats: Dictionary
var current_deck: Array

func spawn_player(scene,loc: Marker2D=starting_point) -> Node2D:
	print(get_tree().current_scene)
	print(starting_point)
	var character := load("characters/%s.tscn" % Global.selected_character) #load character scene based on selection
	print(character)
	print("characters/%s.tscn" % Global.selected_character)
	var player_char_node = character.instantiate()
	### STAT AND DECK SETUP ###
	current_stats = Global.meta_character_stats #transfer persistent stats to battle
	current_deck = Deck.meta_deck #transfer persistent deck to battle
	### END SETUP ###
	player_char_node.position = loc.global_position #take passed starting point position and put the character there
	scene.add_child(player_char_node) #add the character to the tree calling the function
	print("Current stats from singleton: ",current_stats)
	print("Current deck from singleton: ",current_deck)
	player_char_node.add_to_group("Player")
	print("    ---- Tree: ",get_tree().get_nodes_in_group("Player"))
	return player_char_node #returns the player_char_node as a value that can be referenced in script calling this func

### YOU WIN ###

func you_win():
	Global.progress_map()
	Global.goto_scene("res://scenes/map.tscn")



func _on_button_pressed():
	you_win()
