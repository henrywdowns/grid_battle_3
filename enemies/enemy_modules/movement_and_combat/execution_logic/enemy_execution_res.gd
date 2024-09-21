extends Resource
class_name EnemyExecution

func execute_combat_and_movement() -> String:
	return "error"# space to define how and when enemy moves or attacks

### NODE REF ###
var enemy_node: Node2D

### UTILITY METHODS ###

func _locate_player_pos() -> Vector2:
	assert(Global.battle_node)
	assert(Global.battle_node.player_char)
	#print("Player character exists: ", Global.battle_node.player_char)
	if Global.battle_node.player_char.character_coords == null:
		print_debug("Warning no coords for some reason")
		print_debug(Global.battle_node.player_char.character_coords)
	assert(Global.battle_node.player_char.character_coords != null)
	var pc_coords = Global.battle_node.player_char.character_coords
	return pc_coords
	
func _get_self_coords() -> Vector2:
	return enemy_node.enemy_coords #s node that owns this needs to adjust var enemy_node in its ready()

func _determine_row_lined_up() -> bool:
	if _locate_player_pos().y == _get_self_coords().y:
		return true
	else:
		return false
