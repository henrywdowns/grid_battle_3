extends MovementBehavior
class_name JumpRandEnemyPanel

# jump to a random red panel
func _action_pattern(_enemy):
	var enemy_x = _enemy.enemy_coords[0]
	var enemy_y = _enemy.enemy_coords[1]  # Enemy's vertical (y-axis) position
	var target_panel = Global.enemy_panels.pick_random()
	while !_check_if_legal_space(target_panel):
		target_panel = Global.enemy_panels.pick_random()
	
	# Update the enemy's global position based on its new coordinates
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	
