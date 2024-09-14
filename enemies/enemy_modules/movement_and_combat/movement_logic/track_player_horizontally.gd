extends MovementBehavior
class_name TrackHorizontal

#TODO: NEED SLIGHT DELAY BETWEEN PLAYER MOVEMENT AND ENEMY MOVEMENT

func _move_pattern(_enemy):
	attack_start.emit()
	var enemy_y = _enemy.enemy_coords[1]  # Enemy's vertical (y-axis) position
	var player_y = _locate_player_pos()[1]  # Player's vertical (y-axis) position
	
	print("Enemy y: ", enemy_y, "\nPlayer y: ", player_y)
	
	# Check if the enemy needs to move vertically
	if enemy_y > player_y:
		# Enemy is below the player, so move up
		var pre_coords = _enemy.enemy_coords
		_enemy.enemy_coords += Vector2(0, -1)  # Move up (negative y)
		print("Enemy moved up from coords ", pre_coords, " to coords ", _enemy.enemy_coords)
	elif enemy_y < player_y:
		# Enemy is above the player, so move down
		var pre_coords = _enemy.enemy_coords
		_enemy.enemy_coords += Vector2(0, 1)  # Move down (positive y)
		print("Enemy moved down from coords ", pre_coords, " to coords ", _enemy.enemy_coords)

	# Update the enemy's global position based on its new coordinates
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
	
	attack_complete.emit()


func _check_if_legal_move():
	pass
