extends Node

@onready var input : AudioStreamPlayer = $Input
var index : int
var effect : AudioEffectCapture
var playback : AudioStreamGeneratorPlayback
@export var outputPath : NodePath
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setupAudio(id):
	set_multiplayer_authority(id)
	if is_multiplayer_authority():
		input.stream = AudioStreamMicrophone.new()
		input.play()
		index = AudioServer.get_bus_index("Record")
		effect = AudioServer.get_bus_effect(index,0) #Capture

	playback = get_node(outputPath).get_stream_playback() 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
