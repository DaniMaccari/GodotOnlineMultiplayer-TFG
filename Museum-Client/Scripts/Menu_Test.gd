extends Control

@export var ADDRESS = "127.0.0.1"
#IP local: "127.0.0.1"
#private ipv6
@export var PORT = 8080
var max_clients = 8
var peer

var playerNick = ""

func _ready():
	multiplayer.peer_connected.connect(PlayerJustConnected)
	multiplayer.peer_disconnected.connect(PlayerJustDisconnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)
	
	if "--server" in OS.get_cmdline_args(): #si es iniciado con esta linea de comando
		HostGame()
		
	$ServerBrowser.joinGame.connect(JoinByIp)
	pass # Replace with function body.

# called on both sides
func PlayerJustConnected(id):
	print("player connected ", id)

func PlayerJustDisconnected(id):
	print("player disconnected", id)
	#erase player from game
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()

# called only in client side
func ConnectedToServer():
	print("connected to SERVER")
	playerNick = $LineEdit.text
	SendplayerInformation.rpc_id(1, playerNick, multiplayer.get_unique_id())

func ConnectionFailed():
	print("connection FAILED")

@rpc("any_peer")
func SendplayerInformation(nickName, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": nickName,
			"id": id,
			"score": 0,
			"badguy": false,
			"handcuffed": false
		}
		
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendplayerInformation.rpc(GameManager.Players[i].name, i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func HostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, max_clients)
	if error != OK:
		print("coulndt host: ", error)
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")


func _on_host_pressed():
	HostGame()
	playerNick = $LineEdit.text
	SendplayerInformation(playerNick, multiplayer.get_unique_id())
	$ServerBrowser.SetUpBroadCast(playerNick)
	pass

func _on_join_pressed():
	JoinByIp(ADDRESS)
	pass # Replace with function body.

func JoinByIp(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_pressed():
	GameManager.selectBadGuys()
	StartGame.rpc()
	pass # Replace with function body.

@rpc("any_peer", "call_local", "reliable")
func StartGame():
	$ServerBrowser/BroadcastTimer.queue_free()
	var scene = load("res://Scenes/ShaderViewport.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
	
