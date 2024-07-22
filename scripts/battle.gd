extends Node2D

@onready var accepting_input = true
var movement_directions = ["Up","Down","Left","Right"]

func _ready():
	build_stage()
	starting_point = gridpoints[4]
	spawn_player(self)

func _input(event):
	if accepting_input == true:
		if event in movement_directions:
			move_char(event)
	#put attacks here too once those are up

### BATTLE SCENE CONSTRUCTION AND CONTROLS ###

var gridpoints = []
var panels = []
var starting_point: Marker2D

func build_stage():
	for panel in 	$"Arena Panels".get_children():
		#this works its way down vertically left horizontally. ie x0y1 -> x0y2 -> x1y0
		panels.append(panel)
		gridpoints.append(panel.get_children()[0])


### new movement plan:
#going to throw away the coordinate system.
#instead of doing the math every time to calculate a hit (which means lots of different logic
#depending on attacks, i'm going to make characters snap to marker2d like before, but they will
#have hitboxes that just confirm to the entire panel they're on. then attacks will similarly 
#launch projectiles with hitboxes oriented to the height of they panels they should be on, allowing
#for more seamless collision detection and tween movement from panel to panel. it's more flexible.


func move_char(dir):
	pass

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
	var player_char = character.instantiate()
	### STAT AND DECK SETUP ###
	current_stats = Global.meta_character_stats #transfer persistent stats to battle
	current_deck = Deck.meta_deck #transfer persistent deck to battle
	### END SETUP ###
	player_char.position = loc.global_position #take passed starting point position and put the character there
	scene.add_child(player_char) #add the character to the tree calling the function
	print("Current stats from singleton: ",current_stats)
	print("Current deck from singleton: ",current_deck)
	player_char.add_to_group("Player")
	print("    ---- Tree: ",get_tree().get_nodes_in_group("Player"))
	return player_char #returns the player_char node as a value that can be referenced in script calling this func

### YOU WIN ###

func you_win():
	Global.progress_map()
	Global.goto_scene("res://scenes/map.tscn")



func _on_button_pressed():
	you_win()
