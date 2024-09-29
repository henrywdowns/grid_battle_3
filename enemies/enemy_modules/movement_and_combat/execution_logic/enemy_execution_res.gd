extends Resource
class_name EnemyExecution

signal execute_start
signal execute_complete
signal p_timer_timeout

### MOVEMENT / COMBAT ARRAYS ###
@export var sequence: Array[AIBehavior]

### GENERAL VARS ###
var enemy_node: Node2D # for node ref
var is_executing: bool = false
@export var exec_name: String

### TIMERS ###
@export var pattern_timer_interval: float

### MAIN METHODS ###

func _start() -> void:
	execute_start.emit()

func _finish() -> void:
	execute_complete.emit()

func execute_combat_and_movement(_enemy,seq_index) -> void:
	print_debug("Current execute index: ",seq_index)

	_start()
	if sequence and seq_index >= 0 and seq_index < sequence.size() and is_instance_valid(sequence[seq_index]):
		sequence[seq_index]._action_pattern(_enemy)
	elif seq_index == len(sequence):
		print_debug("sequence_finished")
		_finish()
	elif sequence:
		print_debug("Invalid sequence index")
	else:
		print_debug("No sequence or invalid sequence")

### UTILITY METHODS ###

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

func _determine_row_lined_up() -> bool:
	if _locate_player_pos().y == _get_self_coords().y:
		return true
	else:
		return false
