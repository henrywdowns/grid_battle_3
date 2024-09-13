extends MovementBehavior

#TODO: NEED SLIGHT DELAY BETWEEN PLAYER MOVEMENT AND ENEMY MOVEMENT

func _move_pattern(_enemy):
	var enemy_loc = _enemy.enemy_coords[1]
	var player_loc = _locate_player_pos()[1]
	if enemy_loc > player_loc:
		enemy_loc += 1
	elif enemy_loc < player_loc:
		enemy_loc -= 1
