extends Node
class_name MapGenerator

### MAP VARIABLES ###
const X_DIST := 200
const Y_DIST := 150
const PLACEMENT_RANDOMNESS := 50
const FLOORS := 15
const MAP_WIDTH := 7
const PATHS := 6

### ROOM WEIGHTS - ADJUST _setup_random_room_weights() IF CHANGING THIS ###
const MONSTER_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0


var random_room_type_weights = {
	MapNode.MapNodeType.COMBAT: 0.0,
	MapNode.MapNodeType.CAMPFIRE: 0.0,
	MapNode.MapNodeType.SHOP: 0.0
}
var random_room_type_total_weight := 0
var map_data: Array[Array]

func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
	
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()

	return map_data
	
func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_rooms: Array[MapNode] = []
		
		for j in MAP_WIDTH:
			var current_room := MapNode.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			# Boss room has a non-random Y val
			if i == FLOORS - 1:
				current_room.position.y = (i + 1) * -Y_DIST
				
			adjacent_rooms.append(current_room)
		result.append(adjacent_rooms)
	return result

func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0,MAP_WIDTH -1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			y_coordinates.append(starting_point)
	return y_coordinates

func _setup_connection(i: int, j: int) -> int:
	#print_debug("this is in fact happening")
	var next_room: MapNode
	var current_room := map_data[i][j] as MapNode
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH -1)
		next_room = map_data[i + 1][random_j]
	current_room.next_rooms.append(next_room)
	return next_room.column
	
func _would_cross_existing_path(i: int, j: int, room: MapNode) -> bool:
	var left_neighbor: MapNode
	var right_neighbor: MapNode
	
	# if j == 0, there's no left neighbor
	if j > 0:
		left_neighbor = map_data[i][j - 1]
	if j < MAP_WIDTH - 1:
		right_neighbor = map_data[i][j + 1]
	
	# can't cross to right if right neighbor goes to left
	if right_neighbor and room.column > j: 
		for next_room: MapNode in right_neighbor.next_rooms:
			if next_room.column < room.column:
				return true
	# can't cross to left if left neighbor goes to right
	if left_neighbor and room.column < j:
		for next_room: MapNode in left_neighbor.next_rooms:
			if next_room.column > room.column:
				return true
	return false

func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle] as MapNode
	
	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS -2][j] as MapNode
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[MapNode]
			current_room.next_rooms.append(boss_room)
		
		boss_room.map_node_type = MapNode.MapNodeType.BOSS_COMBAT

func _setup_random_room_weights() -> void:
	random_room_type_weights[MapNode.MapNodeType.COMBAT] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[MapNode.MapNodeType.CAMPFIRE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	random_room_type_weights[MapNode.MapNodeType.SHOP] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	
	random_room_type_total_weight = random_room_type_weights[MapNode.MapNodeType.SHOP]
	
func _setup_room_types() -> void:
	# first floor is always a battle
	for room: MapNode in map_data [0]:
		if room.next_rooms.size() > 0:
			room.map_node_type = MapNode.MapNodeType.COMBAT
	
	# middle floor is always a treasure
	for room: MapNode in map_data[floori(FLOORS * 0.5)]:
		if room.next_rooms.size() > 0:
			room.map_node_type = MapNode.MapNodeType.TREASURE
	
	# last floor before boss is always a campfire
	for room: MapNode in map_data[FLOORS - 2]:
		if room.next_rooms.size() > 0:
			room.map_node_type = MapNode.MapNodeType.CAMPFIRE
	
	# rest of rooms
	for current_floor in map_data:
		for room: MapNode in current_floor:
			for next_room: MapNode in room.next_rooms:
				if next_room.map_node_type == MapNode.MapNodeType.NOT_ASSIGNED:
					_set_room_randomly(next_room)

func _set_room_randomly(room_to_set: MapNode) -> void:
	#random room rules
	var campfire_below_4 := true
	var consecutive_campfire := true
	var consecutive_shop := true
	var campfire_on_13: = true
	
	var type_candidate: MapNode.MapNodeType
	
	while campfire_below_4 or consecutive_campfire or consecutive_shop or campfire_on_13:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_campfire := type_candidate == MapNode.MapNodeType.CAMPFIRE
		var has_campfire_parent := _room_has_parent_of_type(room_to_set, MapNode.MapNodeType.CAMPFIRE)
		var is_shop := type_candidate == MapNode.MapNodeType.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, MapNode.MapNodeType.SHOP)
		
		campfire_below_4 = is_campfire and room_to_set.row < 3
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shop = is_shop and has_shop_parent
		campfire_on_13 = is_campfire and room_to_set.row == 12
		
		room_to_set.map_node_type = type_candidate

func _room_has_parent_of_type(room: MapNode, type: MapNode.MapNodeType) -> bool:
	var parents: Array[MapNode] = []
	# left parent
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column -1] as MapNode
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# parent below
	if room.row > 0:
		var parent_candidate := map_data[room.row -1][room.column] as MapNode
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# parent right
	if room.column < MAP_WIDTH -1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as MapNode
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	for parent: MapNode in parents:
		if parent.map_node_type == type:
			return true
	
	return false
	

func _get_random_room_type_by_weight() -> MapNode.MapNodeType:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: MapNode.MapNodeType in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return MapNode.MapNodeType.COMBAT
