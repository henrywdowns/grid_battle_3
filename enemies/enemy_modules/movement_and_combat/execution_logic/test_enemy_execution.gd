extends EnemyExecution

func execute_movement_and_combat() -> String:
	if _determine_row_lined_up():
		return "combat"
	else:
		return "movement"
