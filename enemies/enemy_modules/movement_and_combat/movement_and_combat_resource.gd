extends Resource
class_name AIBehavior

### NODE REF ###
var enemy_node: Node2D

enum CombatOrMovement { COMBAT, MOVEMENT }
@export var combat_or_movement: CombatOrMovement

func _process(_delta) -> void:
	pass

func _locate_player_pos() -> Vector2:
	assert(Global.battle_node)
	assert(Global.battle_node.player_char)
	assert(Global.battle_node.character_coords)
	var pc_coords = Global.battle_node.player_char.character_coords
	return pc_coords
	
func _get_self_coords() -> Vector2:
	return enemy_node.enemy_coords # node that owns this needs to adjust var enemy_node in its ready()


func _move_pattern(_enemy):
	pass
	
func _combat_pattern(_enemy):
	pass
