extends Node3D

var PORT = 8080
var IP_ADDRESS = "127.0.0.1" #local IP
#var ip_address = "194.163.168.245" #myServer IP
@export var player_scene: PackedScene


func _ready():
	start_client()
	_add_player()
	pass # Replace with function body.

func start_client():
	# Create client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
