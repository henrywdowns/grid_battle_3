extends Resource
class_name EnemyExecution

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

func _process(_delta: float):
	if p_timer_on:
		pattern_timer += _delta
	if a_timer_on:
		attack_timer += _delta
	if m_timer_on:
		move_timer += _delta
	if is_executing and pattern_timer >= pattern_timer_interval:
		execute_combat_and_movement(enemy_node)

func _start(entity: Node) -> void:
	current_index = 0
	is_executing = true
	p_timer_on = true

func _finish() -> void:
	is_executing = false
	p_timer_on = false
	a_timer_on = false
	m_timer_on = false

func execute_combat_and_movement(_enemy) -> String:
	if sequence and is_instance_valid(sequence[current_index]):
		sequence[current_index].movement_pattern(_enemy)
		current_index += 1
	else:
		_finish()
	return "error"# space to define how and when enemy moves or attacks

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
