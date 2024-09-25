extends Resource
class_name AIBehavior

### NODE REF ###
var enemy_node: Node2D

### LOGIC INIT ###
enum CombatOrMovement { COMBAT, MOVEMENT }
@export var combat_or_movement: CombatOrMovement
@export var pattern_name: String
signal attack_start
signal attack_complete
signal move_start
signal move_complete


func _ready():
	pass

func _process(_delta) -> void:
	pass

### CHARACTERISTIC METHODS ###

func _action_pattern(_enemy):
	pass


### MOVEMENT UTILITY METHODS ###

func _locate_player_pos() -> Vector2:
	assert(Global.battle_node)
	assert(Global.battle_node.player_char)
	if Global.battle_node.player_char.character_coords == null:
		print_debug("Warning no coords for some reason")
		print_debug(Global.battle_node.player_char.character_coords)
	assert(Global.battle_node.player_char.character_coords != null)
	var pc_coords = Global.battle_node.player_char.character_coords
	return pc_coords
	
func _get_self_coords() -> Vector2:
	return enemy_node.enemy_coords #s node that owns this needs to adjust var enemy_node in its ready()

func move_up(_enemy):
	move_start.emit()
	var target_panel = _enemy.enemy_coords + Vector2.UP
	if _check_if_legal_space(_enemy.enemy_coords + Vector2.UP):
		Events.entity_moved.emit(enemy_node,Global.translate_coords_to_points(_enemy.enemy_coords).get_parent(),Global.translate_coords_to_points(target_panel).get_parent())
		_enemy.enemy_coords = target_panel
		_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	else:
		print_debug("Attempt to move Vector2.UP failed; illegal target panel")
	move_complete.emit()

func move_down(_enemy):
	move_start.emit()
	var target_panel = _enemy.enemy_coords + Vector2.DOWN
	if _check_if_legal_space(target_panel):
		Events.entity_moved.emit(enemy_node,Global.translate_coords_to_points(_enemy.enemy_coords).get_parent(),Global.translate_coords_to_points(target_panel).get_parent())
		_enemy.enemy_coords = target_panel
		_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	else:
		print_debug("Attempt to move Vector2.DOWN failed; illegal target panel")
	move_complete.emit()

func move_left(_enemy):
	move_start.emit()
	var target_panel = _enemy.enemy_coords + Vector2.LEFT
	if _check_if_legal_space(target_panel):
		Events.entity_moved.emit(enemy_node,Global.translate_coords_to_points(_enemy.enemy_coords).get_parent(),Global.translate_coords_to_points(target_panel).get_parent())
		_enemy.enemy_coords = target_panel
		_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	else:
		print_debug("Attempt to move Vector2.LEFT failed; illegal target panel")
	move_complete.emit()

func move_right(_enemy):
	move_start.emit()
	var target_panel = _enemy.enemy_coords + Vector2.RIGHT
	if _check_if_legal_space(target_panel):
		Events.entity_moved.emit(enemy_node,Global.translate_coords_to_points(_enemy.enemy_coords).get_parent(),Global.translate_coords_to_points(target_panel).get_parent())
		_enemy.enemy_coords = target_panel
		_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	else:
		print_debug("Attempt to move Vector2.RIGHT failed; illegal target panel")
	move_complete.emit()

func move_to(_enemy,target_coords: Vector2):
	move_start.emit()
	if _check_if_legal_space(target_coords):
		Events.entity_moved.emit(enemy_node,Global.translate_coords_to_points(_enemy.enemy_coords).get_parent(),Global.translate_coords_to_points(target_coords).get_parent())
		_enemy.enemy_coords = target_coords
		_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	else:
		print_debug("Attempt to move to target coords %s failed; illegal target panel" % target_coords)
	move_complete.emit()

func _check_if_legal_space(_target_panel: Vector2) -> bool:
	var _panel_nodes = Global.battle_node.get_node("Arena Panels").get_children()
	var _target_panel_status_key = Global.translate_coords_to_points(_target_panel).get_parent()
	var panel_status = Global.battle_node.panel_status
	if _target_panel == panel_status[_target_panel_status_key]["panel_coords"]:
		if panel_status[_target_panel_status_key]["occupant"] == null: 
			return true
		else:
			print_debug("Panel occupant is not null. Panel occupant: ",panel_status[_target_panel_status_key]["occupant"])
			return false
	else:
		print_debug("Coords mismatch. Attempted target coords ",_target_panel," did not match panel status coords ",panel_status[_target_panel_status_key]["panel_coords"])
		return false
	return true
