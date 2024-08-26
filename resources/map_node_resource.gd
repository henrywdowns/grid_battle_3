extends Resource

class_name MapNode

enum MapNodeType { NOT_ASSIGNED, COMBAT, ELITE_COMBAT, CAMPFIRE, SHOP, TREASURE, BOSS_COMBAT }

@export var map_node_type: MapNodeType
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[MapNode]
@export var selected := false

func _to_string() -> String:
	return "%s (%s)" % [column, MapNodeType.keys()[map_node_type].substr(0, 2)]
