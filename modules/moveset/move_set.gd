extends Node

### NEED TO SORT OUT FUNC APPLY_EFFECT() ###

var panel_data = {} # Will populate with data from battle.tscn
@onready var basic_attack_card = load(self.get_parent().stats['basic_attack']) ### MAKE A RESOURCE TO REPRESENT DECKS

func _ready():
	call_deferred("_initialize")

func _initialize():
	var battle_scene = get_tree().current_scene
	print(battle_scene)
	if battle_scene:
		panel_data = battle_scene.panel_status

@export var grid_coords: Array = [
	Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
	Vector2(2, 0), Vector2(2, 1), Vector2(2, 2),
	Vector2(3, 0), Vector2(3, 1), Vector2(3, 2),
	Vector2(4, 0), Vector2(4, 1), Vector2(4, 2),
	Vector2(5, 0), Vector2(5, 1), Vector2(5, 2)
]

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

### CONTROLS ### 
@export var accepting_input: bool = true

func _input(_event):
	if accepting_input == true:
		if Input.is_action_just_pressed("Basic"):
			print("attack")
			print(determine_target(0)) # THIS IS RETURNING NULL RIGHT NOW... BUT IT KIND OF WORKS!


func use_card(card):
	determine_target(card.targeting)

func determine_target(target_type):
	var player_location_coords = get_parent().character_coords
	var player_location_gridpoint = get_parent().character_gridpoint
	match target_type:
		TargetType.HITSCAN:
			perform_hitscan(player_location_coords)
		TargetType.PROJECTILE:
			perform_projectile(player_location_gridpoint)

func perform_hitscan(start_position: Vector2, direction: Vector2 = Vector2.RIGHT) -> Vector2:
	# Calculate the endpoint of the hitscan based on direction
	var end_position = start_position + direction * 1000  # Adjust range if needed

	# Find the nearest grid position to the endpoint
	var nearest_target = grid_coords[0]
	var min_distance = end_position.distance_to(nearest_target)
	
	for coord in grid_coords:
		var distance = end_position.distance_to(coord)
		if distance < min_distance:
			min_distance = distance
			nearest_target = coord

	# Check if the nearest target is valid and occupied
	var key = "X%dY%d" % [int(nearest_target.x), int(nearest_target.y)]
	if panel_data.has(key):
		var panel = panel_data[key]
		if panel["status"] == "normal" and panel["occupant"] == null:
			return nearest_target

	# Return an invalid position if no valid target is found
	return Vector2(-1, -1)

func perform_projectile(start_position: Marker2D):
	pass
	
