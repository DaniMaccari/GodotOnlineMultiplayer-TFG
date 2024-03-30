extends Control

@export var ADDRESS = "127.0.0.1"
@export var PORT = 8080
var max_clients = 10
var peer

func _ready():
	multiplayer.peer_connected.connect(PlayerJustConnected)
	multiplayer.peer_disconnected.connect(PlayerJustDisconnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)
	pass # Replace with function body.

# called on both sides
func PlayerJustConnected(id):
	print("player connected ", id)

func PlayerJustDisconnected(id):
	print("player disconnected", id)

# called only in client side
func ConnectedToServer():
	print("connected to SERVER")

func ConnectionFailed():
	print("connection FAILED")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, max_clients)
	if error != OK:
		print("coulndt host: ", error)
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")
	
	pass # Replace with function body.


func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ADDRESS, PORT)
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_pressed():
	StartGame.rpc()
	pass # Replace with function body.

@rpc("any_peer", "call_local", "reliable")
func StartGame():
	var scene = load("res://Scenes/test_movement_scene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
