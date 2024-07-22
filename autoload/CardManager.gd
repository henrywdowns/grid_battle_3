extends Node

### WAREHOUSE FUNCTIONS ###

func access_warehouse(): # for loading card_warehouse.gd - use sparingly
	var warehouse_res = load("res://cards/card_warehouse.gd")
	var warehouse = warehouse_res.new()
	return warehouse

func get_cards(card_group="all"): # for returning a list of available cards
	var warehouse = access_warehouse()
	print("card group: ",card_group)
	match card_group:
		"all":
			return warehouse.all_card_names
		"attack":
			return warehouse.attack_card_list.keys()
		"defense":
			return warehouse.defense_card_list.keys()
		"support":
			return warehouse.support_card_list.keys()
		_:
			print("invalid input for get_cards(), returning NULL")
			return null

func get_card_data(cardname:String): # for returning the actual card data given a name
	print("Searching for ",cardname)
	var warehouse = access_warehouse()
	# First make a dict to direct each card name to its appropriate list
	var card_lists = [warehouse.attack_card_list,warehouse.defense_card_list,warehouse.support_card_list]
	for card_list in card_lists:
		for x in card_list.keys():
			print("x: ",x)
			if x == cardname:
				return [card_list,card_list[x]]
	print("card not found")
	return null

func produce_random_cards_list(count:int=1, card_groups="all"): # produce any number of random selections from card categories
	print("Count: %s card_group: %s" % [count,card_groups])
	var warehouse = access_warehouse()
	var random_cards = []
	if card_groups:
		if ["all","attack","defense","support"].find(card_groups) == -1:
			return "ERROR! wrong input for random cards list"
	var card_list = get_cards(card_groups)
	for x in range(count):
		random_cards.append(card_list[randi_range(0,len(card_list)-1)])
	return random_cards

### FACTORY FUNCTIONS ###

func make_card(dest_scene,card_type,card_name) -> Array:
	print("making card...")
	var new_card = load("res://cards/base_card.tscn")
	print("new card loading... ",new_card)
	var card_resource_path = "res://cards/%s/%s.tres" % [card_type,card_name]
	return [new_card,card_resource_path]
	

#func access_factory(): # for loading card_factory.gd - use sparingly
	#var card_factory_res = load("res://cards/card_factory.gd")
	#var card_factory = card_factory_res.new()
#
#func create_card(cardname,calling_scene=''):
	#var path: String
	#var card_resource # declare variable - will be set as script once cardtype is determined
	#var card_data = CardManager.get_card_data(cardname)
	#var card_node = Node2D.new()
	#print(card_data)
	#match card_data[5]:
		#"attack":
			#card_resource = AttackCard.new()
			#card_resource.card_name = cardname
			#card_resource.card_arcana = card_data[1]
			#card_resource.damage = card_data[2]
			#card_resource.card_target = card_data[3]
			#card_resource.card_rarity = card_data[4]
			#card_resource.card_type = card_data[5]
			#
		#"defense":
			#pass # card_resource = DefenseCard.new()
		#"support":
			#pass # card_resource = SupportCard.new()
		#_:
			#print("Error - invalid card type when creating a card.")
	#if card_resource: #if it's there, return the resource as an object
		#if calling_scene:
			#calling_scene.add_child(card_resource)
			#return
		#card_node.set_script(card_resource)
		#return card_node
	#return null #if it's not there, do nothing
