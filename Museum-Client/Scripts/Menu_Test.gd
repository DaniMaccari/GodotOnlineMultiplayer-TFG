extends Control

@export var ADDRESS = "192.168.1.143" #127.0.0.1
@export var PORT = 8080
var max_clients = 10
var peer

var playerNick = ""

func _ready():
	multiplayer.peer_connected.connect(PlayerJustConnected)
	multiplayer.peer_disconnected.connect(PlayerJustDisconnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)
	
	if "--server" in OS.get_cmdline_args(): #si es iniciado con esta linea de comando
		hostGame()
	pass # Replace with function body.

# called on both sides
func PlayerJustConnected(id):
	print("player connected ", id)

func PlayerJustDisconnected(id):
	print("player disconnected", id)

# called only in client side
func ConnectedToServer():
	print("connected to SERVER")
	SendplayerInformation.rpc_id(1, playerNick, multiplayer.get_unique_id())

func ConnectionFailed():
	print("connection FAILED")

@rpc("any_peer")
func SendplayerInformation(nickName, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
		
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendplayerInformation.rpc(GameManager.Players[i].name, i)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, max_clients)
	if error != OK:
		print("coulndt host: ", error)
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")


func _on_host_pressed():
	hostGame()
	SendplayerInformation(playerNick, multiplayer.get_unique_id())
	pass

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
	
