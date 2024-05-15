extends Control

signal found_server
signal server_removed

var broadcastTimer : Timer

var RoomInfo = {
	"name" : "name",
	"playerCount" : 0
}
var broadcaster : PacketPeerUDP
@export var listenPort : int = 8081
@export var broadcastPort : int = 8082

# Called when the node enters the scene tree for the first time.
func _ready():
	broadcastTimer = $BroadcastTimer
	pass # Replace with function body.

func SetUpBroadCast(name):
	RoomInfo.name = name
	RoomInfo.playerCount = GameManager.Players.size()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address('198.168.56.255', listenPort)
	
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print("Bound to Broadcast Port ", str(broadcastPort), " SUCCESSFUL")
	else:
		print("FAILED to bind to broadcast port")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_broadcast_timer_timeout():
	print("Bradcasting Game!")
	RoomInfo.playerCount = GameManager.Players.size()
	pass # Replace with function body.
