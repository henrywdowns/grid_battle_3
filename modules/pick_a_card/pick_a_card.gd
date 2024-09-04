extends Node
class_name PickACard
var draft_path = load("res://scenes/draft.tscn")
@onready var parent_scene = get_parent()
@onready var viewport_size = get_viewport().size

func _ready():
	print_debug("	### PICK A CARD ###")

func run_draft():
	var draft_scene = draft_path.instantiate() #this is where i call up a draft
	parent_scene.add_child(draft_scene)
	if get_parent().name == ("MapNodes"):
		print("Map draft")
		$MapNodes.visible = false
		draft_scene.draft_multiple(5)
	elif get_parent().name == ("BattleRewards"):
		draft_scene.draft_multiple(1)
