extends Node
class_name RunGame


### SCENE INITIALIZATION ###
const BATTLE_SCENE := preload("res://scenes/battle.tscn")
const MAP_SCENE := preload("res://scenes/map.tscn")
const DRAFT_SCENE := preload("res://scenes/draft.tscn")
const CHAR_SELECT_SCENE := preload("res://scenes/char_select.tscn")
const BATTLE_REWARD_SCENE := preload("res://scenes/battle_rewards.tscn")
const CAMPFIRE_SCENE := preload("res://map_node_rooms/campfire.tscn")
const TREASURE_SCENE := preload("res://map_node_rooms/treasure.tscn")
const SHOP_SCENE := preload("res://map_node_rooms/shop.tscn")


@onready var map: Map = $Map
@onready var current_view: Node = $VisibleScene
@onready var game_data: Node = $GameData
@onready var battle_button: Button = %BattleButton
@onready var map_button: Button = %MapButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton
@onready var deck_view_button: Button = %DeckViewButton


func _ready() -> void:
	Global.run_game_node = $"."
	Global.visible_scene_node = current_view
	if not game_data.selected_character:
		run_char_select()
		_lets_make_it_happen()


func _lets_make_it_happen() -> void:
	_setup_scene_transitions()
	map.generate_new_map()
	map.unlock_floor(0)

### SCENE RUNNING BEHAVIOR ### 

func _change_visible_scene(scene: PackedScene) -> Node:
	print_debug("Changing scene to ",scene)
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

func _setup_scene_transitions() -> void:
	Events.you_win.connect(_change_visible_scene.bind(BATTLE_REWARD_SCENE))
	Events.map_exited.connect(_on_map_exited)
	Events.battle_reward_continue.connect(_show_map)
	Events.campfire_scene_exited.connect(_show_map)
	Events.shop_exited.connect(_show_map)
	Events.treasure_scene_exited.connect(_show_map)

	battle_button.pressed.connect(_change_visible_scene.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_visible_scene.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_visible_scene.bind(BATTLE_REWARD_SCENE))
	shop_button.pressed.connect(_change_visible_scene.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_visible_scene.bind(TREASURE_SCENE))

func _on_map_exited(room) -> void:
	print_debug("Room: ",room,"\nRoom type: ",room.map_node_type)
	match room.map_node_type:
		MapNode.MapNodeType.COMBAT:
			print_debug("changing to combat scene")
			_change_visible_scene(BATTLE_SCENE)
		MapNode.MapNodeType.CAMPFIRE:
			print_debug("changing to campfire scene")
			_change_visible_scene(CAMPFIRE_SCENE)
		MapNode.MapNodeType.SHOP:
			print_debug("changing to shop scene")
			_change_visible_scene(SHOP_SCENE)
		MapNode.MapNodeType.TREASURE:
			print_debug("changing to treasure scene")
			_change_visible_scene(TREASURE_SCENE)
		MapNode.MapNodeType.BOSS_COMBAT:
			print_debug("changing to boss combat scene")
			_change_visible_scene(BATTLE_SCENE)
		_:
			print_debug("Error no mapnodetype")

func run_char_select():
	pass # TODO: 
	# TRIGGERED IN READY() WHEN RUN OPENS UP WITHOUT A LOADED CHARACTER

func _show_battle_rewards():
	var battle_rewards_inst = BATTLE_REWARD_SCENE.instantiate()
	current_view.add_child(battle_rewards_inst)
