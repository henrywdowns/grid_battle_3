extends Node

### Events Bus ###
# Autoload that holds signals so that they can easily be read across disparate nodes.

### UTILITY/GENERIC SIGNALS ###
@warning_ignore("unused_signal")
signal stop_awaiting

### SCENE SIGNALS ###
@warning_ignore("unused_signal")
signal start_game
@warning_ignore("unused_signal")
signal character_selected(character)

### CARD SIGNALS ###
var card_placeholder: Card

@warning_ignore("unused_signal")
signal card_played(card: Card)
@warning_ignore("unused_signal")
signal card_requested(card_name: Card)
@warning_ignore("unused_signal")
signal draft_card_toggled(card:Card)
@warning_ignore("unused_signal")
signal card_chosen()
@warning_ignore("unused_signal")
signal draft_over()
@warning_ignore("unused_signal")
signal emit_node(some_node)
@warning_ignore("unused_signal")
signal card_ui_card_clicked(card:Card)
@warning_ignore("unused_signal")
signal card_ui_debug_update_cards()

### PLAYER SIGNALS ###
@warning_ignore("unused_signal")
signal entity_moved(entity,new_pos: Sprite2D,old_pos: Sprite2D)

### SETTERS ###
@warning_ignore("unused_signal")
signal partition_updated(new_value)

### ENEMY SIGNALS ### 
@warning_ignore("unused_signal")
signal i_died(dead_enemy)

### BATTLE SIGNALS ###
@warning_ignore("unused_signal")
signal you_win()
@warning_ignore("unused_signal")
signal card_ui_available()
@warning_ignore("unused_signal")
signal map_exited(room: MapNode)

### BATTLE REWARD SIGNALS ###
@warning_ignore("unused_signal")
signal battle_reward_continue

### SHOP SIGNALS ###
@warning_ignore("unused_signal")
signal shop_exited

### TREASURE SIGNALS ###
@warning_ignore("unused_signal")
signal treasure_scene_exited

### CAMPFIRE SIGNALS ###
@warning_ignore("unused_signal")
signal campfire_scene_exited

### SEQUENCE EXECUTION SIGNALS ###
@warning_ignore("unused_signal")
signal execute_complete
