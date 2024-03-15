extends Node

var network = NetworkedMultiplayerENet.new()
var max_players = 100 
var max_lobby_players = 10
var port = 1909

func _ready():
	start_server()

func start_server():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("server is UP")

	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
