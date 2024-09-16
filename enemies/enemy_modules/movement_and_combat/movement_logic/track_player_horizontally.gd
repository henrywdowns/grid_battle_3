extends MovementBehavior
class_name TrackHorizontal

#TODO: NEED SLIGHT DELAY BETWEEN PLAYER MOVEMENT AND ENEMY MOVEMENT

func _move_pattern(_enemy):
	attack_start.emit()
	var enemy_y = _enemy.enemy_coords[1]  # Enemy's vertical (y-axis) position
	var player_y = _locate_player_pos()[1]  # Player's vertical (y-axis) position
	
	if enemy_y > player_y:
		var temp_coords = _enemy.enemy_coords
		move_up(_enemy)

	elif enemy_y < player_y:
		var temp_coords = _enemy.enemy_coords
		move_down(_enemy)

	# Update the enemy's global position based on its new coordinates
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	
	attack_complete.emit()


func _check_if_legal_move():
	pass
