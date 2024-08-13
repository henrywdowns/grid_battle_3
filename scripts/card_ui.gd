extends Control

### INTENT ###
# MMBN-style card selection that pauses the battle every so often to "draw" new cards.

var open_hand_available := false
var current_time: float = 0.0
var card_ui_open := false

func _ready():
	z_index = 15
	$".".visible = false
	print("Visibility: ",$".".visible)
	$".".process_mode = Node.PROCESS_MODE_ALWAYS
	print_debug($".".process_mode)
	init_timer()
	open_selector()

func _input(_event):
	#if Input.is_action_just_pressed("Pause"):
		#print_debug("Pausing...")
		#pause_game()
	if Input.is_action_just_pressed("Open Hand") and open_hand_available:
		open_selector()

func _process(delta):
	if !$CardTimer.is_stopped():
		$CardTimer/TimerLabel.text = str(snapped($CardTimer.time_left,0.01))

### CARD SELECTOR BEHAVIOR ###
func open_selector():
	print_debug("Opening selector")
	pause()

func _on_card_timer_timeout():
	open_hand_available = true
	print_debug("Hand is ready")

### BUTTON BEHAVIOR ###

func _on_submit_hand_button_up():
	resume()
	$CardTimer/TimerLabel.text = str($CardTimer.wait_time)
	print($CardTimer.wait_time)
	$CardTimer.start()
	print($CardTimer.is_stopped())
	print_debug("Timer started")
	open_hand_available = false

### TIMER BEHAVIOR ###
func init_timer():
	$CardTimer.wait_time = 5
	$CardTimer.one_shot = true
	print_debug("Timer initiated")

### PAUSE BEHAVIOR ###

func resume():
	print_debug("Resume game: ",get_tree().paused)
	$".".visible = false
	get_tree().paused = false
	print_debug("Resume game 2: ",get_tree().paused)
	print("Visibility: ",$".".visible)
	card_ui_open = false

func pause():
	print_debug("Pause: ",get_tree().paused)
	$".".visible = true
	get_tree().paused = true
	print_debug("Pause 2: ",get_tree().paused)
	print("Visibility: ",$".".visible)
	card_ui_open = true

func pause_game():
	print_debug("Pause game: ",get_tree().paused)
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()
	print_debug("Pause game 2: ",get_tree().paused)
	print("Visibility: ",$".".visible)




