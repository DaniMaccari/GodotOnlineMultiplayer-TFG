extends Node

var peer = WebSocketMultiplayerPeer.new()

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


func _ready():
	pass # Replace with function body.


func _process(delta):
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			print(data)
	pass

func ConnecToServer(ip):
	peer.create_client("ws://127.0.0.1:8085")#change for ip later
	print("Started Client")
	

func _on_start_client_button_button_down():
	ConnecToServer("") #empty for now
	pass # Replace with function body.


func _on_button_button_down():
	var message = {
		"message" : Message.join,
		"data" : "test"
	}
	
	var messageBytes = JSON.stringify(message).to_utf8_buffer()
	peer.put_packet(messageBytes)
	pass # Replace with function body.




