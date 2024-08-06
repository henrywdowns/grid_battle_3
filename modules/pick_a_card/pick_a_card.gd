extends Node

var draft_path = load("res://scenes/draft.tscn")


func run_draft():
	var parent_scene = get_parent()
	var draft_scene = draft_path.instantiate() #this is where i call up a draft
	draft_scene.global_position = parent_scene.get_node("DraftPosition").position
	print(draft_scene)
	parent_scene.add_child(draft_scene)
	if parent_scene.get_node("MapNodes"):
		$MapNodes.visible = false
