extends Node2D
### DEBUG STUFF ###
var num_of_map_drafts = 1 # adjust this in run_draft() later

@onready var map_node_array = $MapNodes.get_children()
var draft_path = load("res://scenes/draft.tscn")

func _ready():
	Events.draft_over.connect(show_nodes_after_draft)
	for x in map_node_array:
		if map_node_array.find(x) == Global.current_encounter:
			x.disabled = false
		else:
			x.disabled = true
		x.pressed.connect(button_behavior)
	if Global.current_encounter == 0:
		run_draft()

func show_nodes_after_draft():
	if !$MapNodes.visible:
		$MapNodes.visible = true
	else:
		print_debug("Map Nodes already visible")

func button_behavior(_index=0):
	Global.goto_scene("res://scenes/battle.tscn")

func run_draft(): # THE MAP DRAFT SHOULD BE A FULL-ON DRAFT FROM AVAILABLE CARD-POOL. NEED TO REWORK
	var draft_scene = draft_path.instantiate() #this is where i call draft. i think i just want this
	# at the beginning of the map, not at every node.
	draft_scene.global_position = $DraftPosition.position
	draft_scene.determine_pool("map_draft")
	$".".add_child(draft_scene)
	draft_scene.draft_multiple(num_of_map_drafts)
	$MapNodes.visible = false
