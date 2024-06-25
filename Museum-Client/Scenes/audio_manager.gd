extends Node

@onready var input : AudioStreamPlayer = $Input
var index : int
var effect : AudioEffectCapture
var playback : AudioStreamGeneratorPlayback
@export var outputPath : NodePath #so I can reference this later
var inputThreshold = 0.05
var receiveBuffer := PackedFloat32Array()
var myID

# Called when the node enters the scene tree for the first time.
func _ready():
	#playback = get_node(outputPath).get_stream_playback() 
	pass
	
func setupAudio(id):
	
	myID = id
	set_multiplayer_authority(id)
	
	if is_multiplayer_authority():
		print("multiplayer authority - ", id)
		input.stream = AudioStreamMicrophone.new()
		input.play()
		index = AudioServer.get_bus_index("Record")
		effect = AudioServer.get_bus_effect(index, 0) # Capture

	playback = get_node(outputPath).get_stream_playback() 
	print(playback, " - ", myID)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		processMic()
	processVoice()

func processMic():
	if effect == null:
		return

	var sterioData : PackedVector2Array = effect.get_buffer(effect.get_frames_available())
	
	if sterioData.size() > 0:
		var data = PackedFloat32Array()
		data.resize(sterioData.size())
		var maxAmplitude := 0.0 # If the max value is high enough to send this data
		
		for i in range(sterioData.size()):
			var value = (sterioData[i].x + sterioData[i].y) / 2 # Average of the two values
			maxAmplitude = max(value, maxAmplitude)
			data[i] = value
			
		if maxAmplitude < inputThreshold: # For example, in mute
			return
	
		#print(data)
		sendData.rpc(data)
		#sendData(data)

func processVoice():
	if receiveBuffer.size() <= 0:
		return
	
	for i in range(min(playback.get_frames_available(), receiveBuffer.size())):
		playback.push_frame(Vector2(receiveBuffer[0], receiveBuffer[0]))
		receiveBuffer.remove_at(0)

@rpc("any_peer", "call_remote", "unreliable_ordered")
func sendData(data : PackedFloat32Array):
	receiveBuffer.append_array(data)
