extends Node

### NEED TO SORT OUT FUNC APPLY_EFFECT() ###

### INITIALIZATION ###

var panel_data = {} # Will populate with data from battle.tscn
@onready var basic_attack_card = load(self.get_parent().stats['basic_attack']) ### MAKE A RESOURCE TO REPRESENT DECKS

func _ready():
	call_deferred("_initialize")

func _initialize():
	var battle_scene = get_tree().current_scene
	print(battle_scene)
	if battle_scene:
		panel_data = battle_scene.panel_status
	grid_points = Array(panel_data.keys())

@export var grid_coords: Array = [
	Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
	Vector2(2, 0), Vector2(2, 1), Vector2(2, 2),
	Vector2(3, 0), Vector2(3, 1), Vector2(3, 2),
	Vector2(4, 0), Vector2(4, 1), Vector2(4, 2),
	Vector2(5, 0), Vector2(5, 1), Vector2(5, 2)
]

var grid_points = []

### HELPER STUFF ###

enum TargetType { 
	HITSCAN, 
	PROJECTILE, 
	AREA, 
	SELF, 
	NONE, 
	PIERCE, 
	TARGET_ALREADY_PROVIDED, 
	MULTI_TARGETS_PROVIDED, 
	CHAIN, 
	LINE, 
	SPLIT, 
	RANDOM, 
	NEAREST, 
	FURTHEST }

func translate_coords_to_points(coords):
	var target_index = grid_coords.find(coords)
	return grid_points[target_index]
#
func translate_points_to_coords(points):
	var target_index =grid_points.find(points)
	return grid_coords[target_index]

### CONTROLS ### 
@export var accepting_input: bool = true

func _input(_event):
	if accepting_input == true:
		if Input.is_action_just_pressed("Basic"):
			print("basic_attack")
			use_card(basic_attack_card)
		if Input.is_action_just_pressed("Card"):
			print("Card played")
			var player_hand = get_parent().get_node("PlayerHand").player_hand
			if len(player_hand)>0:
				print(player_hand[0])
				var first_card_in_hand = load("res://cards/%s" % player_hand[0])
				print("First card: ", first_card_in_hand)
				use_card(first_card_in_hand)
			else:
				print("Empty hand")
### CARD USAGE ###

func use_card(card):
	print(card)
	print(card.targeting)
	var card_target = determine_target(card.targeting)
	print(card_target)
	if card_target:
		if card_target[0]:
			card.unique_effect(card_target)
	else:
		print("No target")
	Events.card_played.emit(card)

### TARGET LOCATION -- THIS ONE WILL BE LONG AND BRUTAL ###

func determine_target(target_type) -> Array:
	var player_location_coords = get_parent().character_coords
	var target_result = []
	print(get_parent())
	#print("Player location coords: %s" % player_location_coords)
	var player_location_gridpoint = get_parent().character_gridpoint
	match target_type:
		TargetType.HITSCAN:
			print("### HITSCAN ###")
			target_result.append(perform_hitscan(player_location_coords))
		TargetType.PROJECTILE:
			perform_projectile(player_location_gridpoint)
		TargetType.NONE:
			pass
	return target_result

func perform_hitscan(start_position: Vector2, direction: Vector2 = Vector2.RIGHT):
	var hitscan_pointer = start_position
	for x in range(6):
		hitscan_pointer += Vector2.RIGHT
		var pointer_grid_point = translate_coords_to_points(hitscan_pointer)
		if panel_data[pointer_grid_point]["occupant"]:
			return panel_data[pointer_grid_point]["occupant"]
	print("missed")

func perform_projectile(start_position: Marker2D):
	pass
	
