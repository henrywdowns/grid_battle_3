extends Node

### NEED TO SORT OUT FUNC APPLY_EFFECT() ###

### INITIALIZATION ###

var panel_data = {} # Will populate with data from battle.tscn
@onready var basic_attack_card = load(self.get_parent().stats['basic_attack']) ### MAKE A RESOURCE TO REPRESENT DECKS

func _ready():
	print("	move_set node is ready.")
	call_deferred("_initialize")

func _initialize():
	var battle_scene = get_tree().current_scene
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
	HITSCAN, #done
	PROJECTILE, 
	AREA, 
	SELF, #done
	NONE, #done
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
			print(player_hand)
			if len(player_hand)>0:
				var first_card_in_hand = load("res://cards/%s.tres" % player_hand[0])
				print("First card object: ", first_card_in_hand)
				use_card(first_card_in_hand)
			else:
				print("Empty hand")
### CARD USAGE ###

func use_card(card):
	print("	### USE_CARD ###")
	print("Card Node -- ",card)
	if card:
		print("Card targeting enum type -- ",card.targeting)
		var card_target = determine_target(card.targeting)
		print("use_card -- Card target list -- ",card_target)
		if card_target:
			print(card_target)
			if card_target[0]:
				print("Targets: ", card_target)
				card.unique_effect(card_target)
		else:
			print("No target")
		Events.card_played.emit(card)
	else:
		print("Error no card")
	print("	### END USE_CARD ###")

### TARGET LOCATION -- THIS ONE WILL BE LONG AND BRUTAL ###

func determine_target(target_type) -> Array:
	print("	### DETERMINE_TARGET ###")
	var player_location_coords = get_parent().character_coords
	var target_result = []
	print("Node playing card -- ",get_parent())
	#print("Player location coords: %s" % player_location_coords)
	var player_location_gridpoint = get_parent().character_gridpoint
	match target_type:
		TargetType.HITSCAN:
			print(	"### HITSCAN ###")
			target_result.append(perform_hitscan(player_location_coords))
		TargetType.PROJECTILE:
			perform_projectile(player_location_gridpoint)
		TargetType.NONE:
			pass
		TargetType.SELF:
			target_result.append(get_parent())
		TargetType.PIERCE:
			print(	"### PIERCE ###")
			var pierce_result = perform_pierce(player_location_coords)
			if pierce_result:
				target_result += pierce_result
	print("	### END DETERMINE_TARGET ###")
	return target_result

func perform_hitscan(start_position: Vector2, direction: Vector2 = Vector2.RIGHT):
	print("	#hitscan#")
	var hitscan_pointer = start_position
	for x in range(6):
		hitscan_pointer += direction
		var pointer_grid_point = translate_coords_to_points(hitscan_pointer)
		if panel_data[pointer_grid_point]["occupant"]:
			return panel_data[pointer_grid_point]["occupant"]
	print("missed")

func perform_pierce(start_position: Vector2, direction: Vector2 = Vector2.RIGHT):
	print("	#pierce#")
	var pierce_pointer = start_position
	var pierce_targets = []
	for x in range(6):
		pierce_pointer += direction
		print("Pointer -- ",pierce_pointer)
		var pointer_grid_point = translate_coords_to_points(pierce_pointer)
		if panel_data[pointer_grid_point]["occupant"]:
			print("Occupant found -- ",panel_data[pointer_grid_point]["occupant"])
			pierce_targets.append(panel_data[pointer_grid_point]["occupant"])
	if len(pierce_targets) > 0:
		print(pierce_targets)
		return pierce_targets
	print("missed")

func perform_projectile(start_position: Marker2D):
	pass
