extends Control

var multiplayer_peer = ENetMultiplayerPeer.new
var connected_peer_ids = []

var MAX_CLIENTS = 100 
var max_lobby_players = 10
var PORT = 8080
var network

func _ready():
	start_server()

func start_server():
	
	multiplayer.peer_connected.connect(self._on_client_connected)
	#disconnected escribir
	
	network = ENetMultiplayerPeer.new()
	network.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = network
	#get_tree().network_peer = network
	print("server is UP")
	


func _on_client_connected(client_id):
	print("client ", str(client_id))
	await get_tree().create_timer(1).timeout
	rpc_id(client_id, "add_previously_connected_player_characters", connected_peer_ids)
	
	rpc_id(client_id, "add_newly_connected_player_character", client_id)
	add_player_character(client_id)

func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://client/PlayerCharacter.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	
	

@rpc("call_remote")
func add_newly_connected_player_character(new_peer_id):
	pass
		
@rpc("call_remote")
func add_previously_connected_player_characters(peer_ids):
	pass
