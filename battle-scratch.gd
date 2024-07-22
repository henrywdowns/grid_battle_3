extends Node2D

@onready var gridpanels = $"Arena Panels".get_children()
@onready var accepting_input = true
var movement_directions = ["Up","Down","Left","Right"]
var battle_started = false
var player_grid_loc: Vector2 = Vector2(1,1)
var gridpoints = []
var grid_coords = [
	Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
	Vector2(2, 0), Vector2(2, 1), Vector2(2, 2),
	Vector2(3, 0), Vector2(3, 1), Vector2(3, 2),
	Vector2(4, 0), Vector2(4, 1), Vector2(4, 2),
	Vector2(5, 0), Vector2(5, 1), Vector2(5, 2)
] # For computing where character is, and where they can move. line these up with gridpoints
  # by using list indices (gridpoints[0] == grid_coords[0] and vice versa
var legal_panels = [
	Vector2(0,0),Vector2(1,0),Vector2(2,0),
	Vector2(0,1),Vector2(1,1),Vector2(2,1),
	Vector2(0,2),Vector2(1,2),Vector2(2,2)
	]

var coords_current_state = {}

var player_instance: Node2D #empty node which will be assigned the value of the whole loaded character node after it's spawned
var enemy_instance_1: Node2D #empty enemy instance nodes. this is a messy one and i look forward to having a better way to do this
var enemy_instance_2: Node2D
var enemy_instance_3: Node2D

### In-battle variables: ###
var current_projectiles = {}
var current_solid_objects = {}

func _input(_event):
	if accepting_input == true:
		for direction in movement_directions:
			if Input.is_action_just_pressed(direction):
				grid_movement(direction)
		if Input.is_action_just_pressed("Basic Attack"):
			PlayerCharacter.basic_attack()

func _ready():
	print(EnemyHandler.current_enemies)
	var battle_scene = $"."
	print("From battle, battle_scene is: ",battle_scene)
	for i in gridpanels:
		gridpoints.append(i.get_children()[0])
	Global.battle_gridpoints = gridpoints # pass gridpoints array to global for translator
	Global.battle_grid_coords = grid_coords # pass coords array to global too
	print("Stats from battle scene: ",PlayerCharacter.current_stats)
	player_instance = PlayerCharacter.spawn_player(battle_scene,$"Arena Panels/X1Y1/Marker2D")
	enemy_instance_1 = EnemyHandler.test_spawn(battle_scene,$"Arena Panels/X4Y1/Marker2D")
	enemy_instance_2 = spawn_legal_random_enemy()
	for i in EnemyHandler.current_enemies:
		print(i)
		print(i.enemy_stats)
	battle_started = true

func _process(_delta):
	if !EnemyHandler.current_enemies:
		you_win()

func _on_button_pressed():
	Global.cleanup()
	Global.goto_scene("res://scenes/main.tscn")

func grid_movement(dir):
	var movement_intent = player_grid_loc
	if dir == "Up":
		movement_intent[1] -= 1
	if dir == "Down":
		movement_intent[1] += 1
	if dir == "Left":
		movement_intent[0] -= 1
	if dir == "Right":
		movement_intent[0] += 1
	if movement_intent in legal_panels:
		player_grid_loc = movement_intent
		var target_index = grid_coords.find(player_grid_loc)
		if target_index != -1:
			player_instance.global_position = gridpoints[target_index].global_position
			print("Player Character moved to %s" % player_grid_loc)
		PlayerCharacter.current_position = player_grid_loc
	else:
		print("Action blocked")

func you_win():
	accepting_input = false
	$BackToMap.visible = true
	$BackToMap/BackToMapButton.disabled = false

func _on_back_to_map_button_button_up():
	Global.goto_scene("res://scenes/map.tscn")
	
func update_coords_current_state():
	var new_coords_current_state = {}
	coords_current_state["Player_Character"] = PlayerCharacter.current_position
	for enemy in EnemyHandler.current_enemies.keys():
		coords_current_state[enemy] = EnemyHandler.current_enemies[enemy]
	for object in current_solid_objects.keys():
		coords_current_state[object] = current_solid_objects[object]
	coords_current_state = new_coords_current_state
	return new_coords_current_state
	
func check_if_panel_legal(panel_coords:Vector2,all_player_or_enemy="all") -> bool:
	update_coords_current_state()
	if panel_coords:
		if all_player_or_enemy == "all":
			print("Evaluating all panels")
			if panel_coords in grid_coords and panel_coords not in coords_current_state:
				return true
		elif all_player_or_enemy == "player":
			print("Evaluating player panels")
			if panel_coords in legal_panels and panel_coords not in coords_current_state:
				return true
		elif all_player_or_enemy == "enemy":
			print("Evaluating enemy panels")
			if panel_coords in grid_coords and panel_coords not in legal_panels and panel_coords not in coords_current_state:
				return true
		else:
			print("Incorrect input - returning false")
			return false
		print("Evaluated false")
		return false
	else:
		print("No panel coords, evaluating false")
		return false

func spawn_legal_random_enemy():
	var legal = false
	var enemy = EnemyHandler.random_enemy_name()
	var panel
	var failsafe = 0
	while legal == false:
		print("Legality check count: ",failsafe)
		failsafe += 1
		if failsafe > 10:
			break
		panel = Global.random_panel("gridpoint")
		legal = check_if_panel_legal(Global.translate_points_to_coords(panel),"enemy")
	EnemyHandler.spawn_enemy(enemy,$".",panel)
