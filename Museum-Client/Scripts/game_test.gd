#extends Node3D
#
#var PORT = 8080
#var IP_ADDRESS = "127.0.0.1" #local IP
#var connected_peer_ids = []
#
#var local_player_character
#var player_character = preload("res://Scenes/player_test.tscn").instantiate()
#
##var ip_address = "194.163.168.245" #myServer IP
#@export var player_scene: PackedScene
#
#
#func _ready():
	#start_client()
	##_add_player_character()
#
#
#func start_client():
	## Create client.
	#var peer = ENetMultiplayerPeer.new()
	#peer.create_client(
		#IP_ADDRESS, 
		#PORT)
	#multiplayer.multiplayer_peer = peer
	#
#
#func add_player_character(peer_id):
	#connected_peer_ids.append(peer_id)
	#player_character.set_multiplayer_authority(peer_id)
	#add_child(player_character)
	#if peer_id == multiplayer.get_unique_id():
		#local_player_character = player_character
#
#@rpc("call_remote")
#func add_newly_connected_player_character(new_peer_id):
	#add_player_character(new_peer_id)
		#
#@rpc("call_remote")
#func add_previously_connected_player_characters(peer_ids):
	#for peer_id in peer_ids:
		#add_player_character(peer_id)
#
#
