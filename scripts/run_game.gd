extends Node
class_name RunGame


### SCENE INITIALIZATION ###
const BATTLE_SCENE := preload("res://scenes/battle.tscn")
const MAP_SCENE := preload("res://scenes/map.tscn")
const DRAFT_SCENE := preload("res://scenes/draft.tscn")
const CHAR_SELECT_SCENE := preload("res://scenes/char_select.tscn")
#TODO
const BATTLE_REWARD_SCENE = 'asdf'
const CAMPFIRE_SCENE = 'asdf'
const TREASURE_SCENE = 'asdf'
const SHOP_SCENE = 'asdf'


@onready var map: Map = $Map
@onready var char_select: Control = $CharSelect
@onready var current_view: Node = $VisibleScene
@onready var game_data: Node = $GameData
@onready var battle_button: Button = %BattleButton
@onready var map_button: Button = %MapButton
@onready var shop_button: Button = %shopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton
@onready var deck_view_button: Button = %DeckViewButton


func _ready() -> void:
	if not game_data.selected_character:
		run_char_select()
		_lets_make_it_happen()


func _lets_make_it_happen() -> void:
	_setup_scene_transitions()
	map.generate_new_map()
	map.unlock_floor(0)


func _change_visible_scene(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_visible_scene := scene.instantiate()
	current_view.add_child(new_visible_scene)
	map.hide_map()
	
	return new_visible_scene

func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	map.show_map()
	map.unlock_next_rooms()

### SCENE RUNNING BEHAVIOR ### 
func _setup_scene_transitions() -> void:
	Events.you_win.connect(_change_visible_scene.bind(BATTLE_REWARD_SCENE))
	#Events.map_exited.connect(_on_map_exited)
	#TODO: Events.battle_reward_exited.connect(_show_map)
	#TODO: Events.campfire_exited.connect(_show_map)
	#TODO: Events.shop_exited.connect(_show_map)
	#TODO: Events.treasure_room_exited.connect(_show_map)

	battle_button.pressed.connect(_change_visible_scene.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_visible_scene.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_visible_scene.bind(BATTLE_REWARD_SCENE))
	#TODO: shop_button.pressed.connect(_change_visible_scene.bind(SHOP_SCENE))
	#TODO: treasure_button.pressed.connect(_change_visible_scene.bind(TREASURE_SCENE))

func _on_map_exited() -> void:
	print("TODO: from the MAP, change view based on MapNodeType")

func run_char_select():
	pass # TODO: 
	# TRIGGERED IN READY() WHEN RUN OPENS UP WITHOUT A LOADED CHARACTER
