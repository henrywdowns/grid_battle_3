extends Node2D
class_name Map
### DEBUG STUFF ###
var num_of_map_drafts = 6 # adjust this in run_draft() later

### INIT STUFF ###
#@onready var map_node_array = $MapNodes.get_children()
var draft_path = preload("res://scenes/draft.tscn")

const SCROLL_SPEED := 15
const MAP_ROOM = preload("res://modules/map_node/map_room.tscn")
const MAP_LINE = preload("res://modules/map_node/map_lines.tscn")

@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %MapNodes
@onready var visuals: Node2D = $Visuals
@onready var camera_2d: Camera2D = $Camera2D

var map_data: Array[Array]
var floors_climbed: int
var last_room: MapNode
var camera_edge_y: float

func _ready():
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1)
	if Global.current_encounter == 0:
		run_draft()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Scroll Up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("Scroll Down"):
		camera_2d.position.y += SCROLL_SPEED
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)

func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map()
	create_map()
	
func create_map() -> void:
	for current_floor: Array in map_data:
		for room: MapNode in current_floor:
			if room.next_rooms.size() > 0:
				_spawn_room(room)
	# Boss room has no next room but needs to be spawned
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_room(map_data[MapGenerator.FLOORS-1][middle])
	
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH -1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2
	
func unlock_floor(which_floor: int = floors_climbed) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true
			
func unlock_next_rooms() -> void:
	for map_room: MapRoom in rooms.get_children():
		map_room.available = true
		
func show_map() -> void:
	show()
	camera_2d.enabled = true
	
func hide_map() -> void:
	hide()
	camera_2d.enabled = false
	
func _spawn_room(room: MapNode) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	if room.selected and room.row < floors_climbed:
		new_map_room.show_selected()

func _connect_lines(room: MapNode) -> void:
	if room.next_rooms.is_empty():
		return
		
	for next: MapNode in room.next_rooms:
		#print_debug("###### Next: ",next, " next rooms: ",room.next_rooms)
		var new_map_line := MAP_LINE.instantiate() as Line2D
		print("Room: ",room, " Room line start: ",room.position, " Next: ",next, " Next line end: ",next.position)
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)
		
func _on_map_room_selected(room: MapNode) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
			
	last_room = room
	floors_climbed += 1
	Events.map_exited.emit(room)

#func show_nodes_after_draft():
	#if !$MapNodes.visible:
		#$MapNodes.visible = true
	#else:
		#print_debug("Map Nodes already visible")

#func button_behavior(_index=0):
	#Global.goto_scene("res://scenes/battle.tscn")

func run_draft(): # THE MAP DRAFT SHOULD BE A FULL-ON DRAFT FROM AVAILABLE CARD-POOL. NEED TO REWORK
	var draft_scene = draft_path.instantiate() #this is where i call draft. i think i just want this
	# at the beginning of the map, not at every node.
	draft_scene.global_position = $DraftPosition.position
	draft_scene.determine_pool("map_draft")
	$".".add_child(draft_scene)
	draft_scene.draft_multiple(num_of_map_drafts)
	$Visuals.visible = false
