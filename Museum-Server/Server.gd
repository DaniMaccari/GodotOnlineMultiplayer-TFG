extends Node3D


var MAX_CLIENTS = 100 
var max_lobby_players = 10
var PORT = 8080
var network

@export var player_scene: PackedScene
#@export var player_scene: PackedScene

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
	print("client ", str(client_id), " connected")
	var player = player_scene.instantiate()
	player.name = str(client_id)
	call_deferred("add_child",player)
