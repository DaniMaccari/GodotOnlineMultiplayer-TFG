extends Control

signal found_server
signal server_removed

var broadcastTimer : Timer

var RoomInfo = {
	"name" : "name",
	"playerCount" : 0
}
var broadcaster : PacketPeerUDP
var listener : PacketPeerUDP

@export var broadcastPort : int = 8082
@export var listenPort : int = 8081
@export var broadcastAddress : String = '198.168.56.255'

# Called when the node enters the scene tree for the first time.
func _ready():
	broadcastTimer = $BroadcastTimer
	
	SetUp() #call only when searching for lobby
	pass

func SetUpBroadCast(name):
	RoomInfo.name = name
	RoomInfo.playerCount = GameManager.Players.size()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcastAddress, listenPort)
	
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print("Bound to Broadcast Port ", str(broadcastPort), " SUCCESSFUL")
	else:
		print("FAILED to bind to broadcast port")
		
	$BroadcastTimer.start()


func _process(delta):
	#print(listener.get_available_packet_count())
	if listener.get_available_packet_count() > 0: #theres something
		var serverip = listener.get_packet_ip()
		var serverport = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		
		print("Server ip: ", serverip," port: ", serverport,"room info: ", roomInfo)
	
	pass


func _on_broadcast_timer_timeout():
	print("Bradcasting Game!")
	RoomInfo.playerCount = GameManager.Players.size()
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)
	pass # Replace with function body.

func SetUp():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	
	if ok == OK:
		print("Bound to Listen Port ", str(listenPort), " SUCCESSFUL")
		$Label.text = "listening: true" #DEBUG
	else:
		print("FAILED to bind to listen port")
		$Label.text = "listening: false" #DEBUG

func CleanUp():
	listener.close()
	
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()
	
	
func _exit_tree():
	CleanUp()





