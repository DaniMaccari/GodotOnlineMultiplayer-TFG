extends Node

enum Message{
	id,
	join,
	userConnected,
	userDisconnected,
	lobby,
	candidate,
	offer,
	answer,
	checkIn
}

var peer = WebSocketMultiplayerPeer.new()


func _ready():
	peer.connect("peer_connected", peer_connected)
	peer.connect("peer_connected", peer_connected)



func _process(delta):
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			print(data)
	pass

func StartServer():
	peer.create_server(8085)
	print("Started Server")

func _on_start_server_button_button_down():
	StartServer()


func _on_button_2_button_down():
	var message = {
		"message" : Message.id,
		"data" : "test"
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())









