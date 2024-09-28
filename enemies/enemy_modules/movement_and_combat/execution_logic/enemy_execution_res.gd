extends Resource
class_name EnemyExecution

signal execute_start
signal execute_complete
signal p_timer_timeout

### MOVEMENT / COMBAT ARRAYS ###
@export var sequence: Array[AIBehavior]

### GENERAL VARS ###
var enemy_node: Node2D # for node ref
var current_index: int = 0
var is_executing: bool = false
@export var exec_name: String

### TIMERS ###
@export var pattern_timer_interval: float
var pattern_timer := 0.00
var p_timer_on := false
var attack_timer := 0.00
var a_timer_on := false
var move_timer := 0.00
var m_timer_on := false

### MAIN METHODS ###

func _process(_delta): # I DONT THINK I CAN USE PROCESS HERE
	if p_timer_on and is_executing:
		pattern_timer += _delta
		if pattern_timer > pattern_timer_interval:
			p_timer_timeout.emit()
			pattern_timer = 0.0

func _start() -> void:
	execute_start.emit()
	current_index = 0
	p_timer_on = true
	is_executing = true

func _finish() -> void:
	is_executing = false
	current_index = 0
	p_timer_on = false
	execute_complete.emit()

func execute_combat_and_movement(_enemy) -> void:
	print_debug("Current execute index: ",current_index)

	_start()
	for action in sequence:
		if current_index > 0:
			print_debug("Awaiting...")
			await p_timer_timeout
		if sequence and is_instance_valid(sequence[current_index]):
			pattern_timer = 0.0
			sequence[current_index]._action_pattern(_enemy)
			current_index += 1
		elif sequence:
			print_debug("Invalid sequence index")
		else:
			print_debug("No sequence or invalid sequence")
		print_debug("Action iteration over")
	_finish()

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
