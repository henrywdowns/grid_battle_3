extends Control

### INTENT ###
# Pause menu accessible anywhere.

func _ready():
	$".".visible = false
	print("Visibility: ",$".".visible)
	$".".process_mode = Node.PROCESS_MODE_ALWAYS
	print_debug($".".process_mode)

func _input(_event):
	if Input.is_action_just_pressed("Pause"):
		print_debug("Pausing...")
		pause_game()

func resume():
	print_debug("Resume game: ",get_tree().paused)
	$".".visible = false
	get_tree().paused = false
	print_debug("Resume game 2: ",get_tree().paused)
	print("Visibility: ",$".".visible)

func pause():
	print_debug("Pause: ",get_tree().paused)
	$".".visible = true
	get_tree().paused = true
	print_debug("Pause 2: ",get_tree().paused)
	print("Visibility: ",$".".visible)

func pause_game():
	print_debug("Pause game: ",get_tree().paused)
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()
	print_debug("Pause game 2: ",get_tree().paused)
	print("Visibility: ",$".".visible)
