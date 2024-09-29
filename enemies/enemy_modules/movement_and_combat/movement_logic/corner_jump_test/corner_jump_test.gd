extends MovementBehavior
class_name CornerJump

func _action_pattern(_enemy):
	if _enemy.enemy_coords == Vector2(3,2):
		move_to(_enemy,Vector2(5,0))
	else:
		move_to(_enemy,Vector2(3,2))
