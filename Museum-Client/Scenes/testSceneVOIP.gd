extends Node2D

@export var CharacterVOIP : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var s = CharacterVOIP.instantiate()
	add_child(s)
	s.get_node("AudioManager").setupAudio(1)
	
	pass # Replace with function body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
