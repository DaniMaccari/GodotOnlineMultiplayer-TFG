extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	name = str(get_multiplayer_authority())


@rpc("unreliable")
func remote_set_position(authority_position): pass

@rpc("authority", "call_local", "reliable", 1)
func display_message(message): pass

@rpc("any_peer", "call_local", "reliable", 1)
func clicked_by_player(): pass
