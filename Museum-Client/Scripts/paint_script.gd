class_name Paint
extends StaticBody3D

var allTextures = [
#    original                              ,   vandaliced 
	["res://paintTextures/paintTest_1a.png", "res://paintTextures/paintTest_1b.png"],
	["res://paintTextures/paintTest_1a.png", "res://paintTextures/paintTest_1b.png"]
]

@export var paintTexture : MeshInstance3D
var paintID : int
var frameRate = 10/1
var lastFrame

func _ready():
	paintID = 0 #number added when games start
	
	paintTexture.material_override.texture = ResourceLoader.load(allTextures[paintID][0])
	#paintTexture.material_override.set_texture(allTextures[paintID][0])


func VandalicePainting():
	print("paint_script -", "PAINTINGG")
	paintTexture.material_override.texture = ResourceLoader.load(allTextures[paintID][1])
	#set in the singleton this paint to VANDALICED TRUE
	pass




