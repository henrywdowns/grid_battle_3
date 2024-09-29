extends MovementBehavior
class_name JumpRandEnemyPanel

# jump to a random red panel
func _action_pattern(_enemy):
	var enemy_panels = Global.enemy_panels.duplicate()
	enemy_panels.shuffle()
	var safety: int = 0
	var enemy_x = _enemy.enemy_coords[0]
	var enemy_y = _enemy.enemy_coords[1]
	var target_panel = Global.translate_points_to_coords(enemy_panels.pop_front())
	while !_check_if_legal_space(target_panel):
		enemy_panels.shuffle()
		target_panel = Global.translate_points_to_coords(enemy_panels.pop_front())
		safety += 1
		if safety > 10:
			break
	move_to(_enemy,target_panel)
