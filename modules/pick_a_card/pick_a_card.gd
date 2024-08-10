extends Node

var draft_path = load("res://scenes/draft.tscn")

func _ready():
	print_debug("	### PICK A CARD ###")

func run_draft():
	var parent_scene = get_parent()
	var draft_scene = draft_path.instantiate() #this is where i call up a draft
	draft_scene.global_position = parent_scene.get_node("DraftPosition").position
	print_debug(draft_scene)
	parent_scene.add_child(draft_scene)
	if get_parent().name == ("MapNodes"):
		$MapNodes.visible = false
		draft_scene.draft_multiple(5)
	elif get_parent().name == ("Battle"):
		draft_scene.draft_cards()
