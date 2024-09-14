extends Resource
class_name AIBehavior

### NODE REF ###
var enemy_node: Node2D
var test_node = " ========================= test"

### LOGIC INIT ###
enum CombatOrMovement { COMBAT, MOVEMENT }
@export var combat_or_movement: CombatOrMovement
signal attack_start
signal attack_complete
signal move_start
signal move_complete


func _ready():
	pass

func _process(_delta) -> void:
	pass

func _locate_player_pos() -> Vector2:
	assert(Global.battle_node)
	assert(Global.battle_node.player_char)
	print("Player character exists: ", Global.battle_node.player_char)
	if Global.battle_node.player_char.character_coords == null:
		print("Warning no coords for some reason")
		print(Global.battle_node.player_char.character_coords)
	assert(Global.battle_node.player_char.character_coords != null)
	var pc_coords = Global.battle_node.player_char.character_coords
	print(pc_coords)
	return pc_coords
	
func _get_self_coords() -> Vector2:
	return enemy_node.enemy_coords #s node that owns this needs to adjust var enemy_node in its ready()


func _move_pattern(_enemy):
	pass
	
func _combat_pattern(_enemy):
	pass
