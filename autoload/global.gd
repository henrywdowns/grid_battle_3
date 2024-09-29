extends Node

### SCENE MANAGEMENT ###

var current_scene = null
var run_game_node: Node
var visible_scene_node: Node
var battle_node: Control

### GRID/PANEL MANAGEMENT ###
var battle_gridpoints = []
var battle_grid_coords = []
var battle_points_to_panels = {}
var enemy_panels: Array
var player_panels: Array

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)
	
### SCENE MANAGEMENT ###

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path) #uses the below function, but does so in a "deferred 
	#state" where it executes during idle time, rather than while other code is still running
	
func _deferred_goto_scene(path): #don't call this scene - call goto_scene(), which calls this scene
	var s = ResourceLoader.load(path) #load new scene
	if not s:
		print_debug("Failed to load scene at path: %s" % path)
		return
	if current_scene:
		current_scene.free() #free old scene
	current_scene = s.instantiate() #instantiate new scene and assign to variable
	get_tree().root.add_child(current_scene) #add new scene as child
	get_tree().current_scene = current_scene #make the new scene the current scene

### CHARACTER MANAGEMENT ###

var selected_character = null
var selected_character_tres = character
var meta_character_stats = {}
var char_res: character

### Map Management ### 

var current_encounter = 0
var current_map = 0

func progress_map():
	current_encounter += 1
	if current_encounter >= 3:
		current_encounter = 0
		current_map += 1
		print_debug("Current deck: %s \nDraft Pool: %s" % [Deck.meta_deck,Deck.draft_pool])
		Deck.meta_deck = []
	print_debug("Progressing map. Current map: %s -- Current encounter: %s" % [current_map,current_encounter])
	

### General Helper Stuff That's Useful All Over ###

var accepting_input = true
@onready var viewport_width = get_viewport().size[0]
@onready var viewport_height = get_viewport().size[1]

### MISC CARRYOVER HELP FUNCS - MAY NOT NEED BUT COULD BE USEFUL ### 

func translate_coords_to_points(coords):
	var target_index = battle_grid_coords.find(coords)
	return battle_gridpoints[target_index]
#
func translate_points_to_coords(points):
	var target_index = battle_gridpoints.find(points)
	return battle_grid_coords[target_index]

#func check_balance_sheet():
	#var balance_sheet_res := load("res://resources/BalanceSheet.gd") # load up the balance sheet so we can access player_stats
	#var balance_sheet = balance_sheet_res.new() #creating an instance of balance_sheet.gd
	#return balance_sheet
#
#func random_panel(coords_or_gridpoint):
	#var _balance_sheet = Global.check_balance_sheet()
	#var random_coords = Vector2(randi_range(0,2),randi_range(3,5))
	#var random_gridpoint: Node2D = Global.translate_coords_to_points(random_coords)
	#if coords_or_gridpoint == "coords":
		#return random_coords
	#elif coords_or_gridpoint == "gridpoint":
		#return random_gridpoint
	#else:
		#print_debug("Incorrect input")
	## will need this for movement to make sure objects move as intended. since each object is tied to a 
	## coord/marker2d and each coord/marker2d is tied to a specific global_position, i think it makes sense
	## to keep track of on-screen objects somewhere (singleton? battle scene?). maybe i make a dict w/ their
	## coords or marker. then this function can check both if a char is moving to a legal panel as well as 
	## an unoccupied panel
#### MOVEMENT/LOCATION NOTES ### 
## gridpoints: collection of Marker2Ds ultimately lending global_position. it's a list of 18 markers.
## grid_coords: collection of Vector2s, which allow me to work with x/y coords instead of Marker2D names. 
## 			   has a corresponding list of 18 Vector2s and equates using indices. this enables simple math
## 			   to be done on locations.
## target_index: where each lives in their list. index of coord in grid_coords list corresponds to index of 
## 			    grid point in gridpoints list
#### EQUATE THESE WITH THIS ###
## 1. target_index = grid_coords.find(player_grid_loc)
## 2. entity.global_position = gridpoints[target_index].global_position	
