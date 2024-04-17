extends StaticBody3D

var allTextures = [
#    original                              ,   vandaliced 
	["res://paintTextures/paintTest_1a.png", "res://paintTextures/paintTest_1b.png"],
	["res://paintTextures/paintTest_1a.png", "res://paintTextures/paintTest_1b.png"]
]

var frameRate = 10/1
var lastFrame

func _ready():
	var random_texture = allTextures[randi() % allTextures.size()]
	var material = StandardMaterial3D.new()
	material.albedo_texture = random_texture
	#set_material(material)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	lastFrame += delta
	if lastFrame >= frameRate:
		lastFrame -= frameRate
		_slow_process(frameRate)

func _slow_process(delta):
	if multiplayer.get_unique_id() == 1:
		pass






