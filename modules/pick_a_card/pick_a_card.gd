extends Node

var draft_path = load("res://scenes/draft.tscn")

func run_draft():
	var parent_scene = get_parent()
	var draft_scene = draft_path.instantiate() #this is where i call draft. i think i just want this
	# at the beginning of the map, not at every node.
	draft_scene.global_position = $DraftPosition.position
	parent_scene.add_child(draft_scene)
	$MapNodes.visible = false
