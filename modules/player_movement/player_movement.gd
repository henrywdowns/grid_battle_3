extends Node

@export var accepting_input: bool = true
var player_char: Node

func _ready():
	player_char = get_parent()
	print("Movement node ready for %s" % player_char)
	print("Movement node is: %s" % self)
	Events.emit_node.emit(self)

### BATTLE STAGE DATA ###
var grid_partition: int
var gridpoints: Array
var grid_coords = [
	Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
	Vector2(2, 0), Vector2(2, 1), Vector2(2, 2),
	Vector2(3, 0), Vector2(3, 1), Vector2(3, 2),
	Vector2(4, 0), Vector2(4, 1), Vector2(4, 2),
	Vector2(5, 0), Vector2(5, 1), Vector2(5, 2)
	]
var movement_directions = ["Up","Down","Left","Right"]
var player_current_panel: Vector2

### PLAYER MOVEMENT ###
func _input(_event):
	if accepting_input == true:
		for direction in movement_directions:
			if Input.is_action_just_pressed(direction):
				print(direction)
				move_char(direction)

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
		player_char.character_gridpoint = gridpoints[target_panel_index]
		player_char.character_coords = player_current_panel
		player_char.global_position = gridpoints[target_panel_index].global_position
