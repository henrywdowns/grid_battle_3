extends Area2D
class_name MapRoom


signal selected(room: MapNode)

const ICONS := {
	MapNode.MapNodeType.NOT_ASSIGNED: [null, Vector2.ONE],
	MapNode.MapNodeType.COMBAT: [preload("res://assets/Map/temp-combat-icon.png"),Vector2.ONE],
	MapNode.MapNodeType.TREASURE: [preload("res://assets/Map/temp-treasure-icon.png"),Vector2.ONE],
	MapNode.MapNodeType.CAMPFIRE: [preload("res://assets/Map/temp-campfire-icon.png"),Vector2.ONE],
	MapNode.MapNodeType.SHOP: [preload("res://assets/Map/temp-shop-icon.png"),Vector2(0.6,0.6)],
	MapNode.MapNodeType.BOSS_COMBAT: [preload("res://assets/Map/temp-boss-icon.png"),Vector2(1.25,1.25)]
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: MapNode : set = set_room ### 1:22:56 https://www.youtube.com/watch?v=7HYu7QXBuCY


#func _ready() -> void:
	#var test_room := MapNode.new()
	#test_room.map_node_type = MapNode.MapNodeType.CAMPFIRE
	#test_room.position = Vector2(100,100)
	#room = test_room
	#
	#await get_tree().create_timer(3).timeout
	#available = true


func set_available(new_value: bool) -> void:
	available = new_value
	if available: 
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")
		
func set_room(new_data: MapNode) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0,360)
	sprite_2d.texture = ICONS[room.map_node_type][0]
	sprite_2d.scale = ICONS[room.map_node_type][1]
	
func show_selected() -> void:
	line_2d.modulate = Color.WHITE

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("LMB"):
		return
		# down the line i might want to reverse this - non-selected nodes in row of chosen node 
		# take on a corrupted missingno-esque look
	room.selected = true
	animation_player.play("select")
	
func _on_map_room_selected() -> void: # called by animationplayer when "select" animation finishes
	selected.emit(room)
	
