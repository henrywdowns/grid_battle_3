extends Node2D

@onready var map_node_array = $MapNodes.get_children()
var draft_path = load("res://scenes/draft.tscn")

func _ready():
	print("draft ready")
	for x in map_node_array:
		if map_node_array.find(x) == Global.current_encounter:
			x.disabled = false
		else:
			x.disabled = true
		x.pressed.connect(button_behavior)
	var draft_scene = draft_path.instantiate()
	draft_scene.global_position = $DraftPosition.position
	$".".add_child(draft_scene)
	Events.draft_over.connect(show_nodes_after_draft)
	$MapNodes.visible = false

func show_nodes_after_draft():
	if !$MapNodes.visible:
		$MapNodes.visible = true
	else:
		print("Map Nodes already visible")

func button_behavior(index=0):
	Global.goto_scene("res://scenes/battle.tscn")

