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
@onready var notPainted : MeshInstance3D = $CollisionShape3D/pintura0
@onready var yesPainted : MeshInstance3D = $CollisionShape3D/pintura1

func _ready():
	paintID = 0 #number added when games start
	
	notPainted.visible = true
	yesPainted.visible = false
	#paintTexture.material_override.set_texture(allTextures[paintID][0])


func VandalicePainting():
	print("paint_script -", "PAINTINGG")
	notPainted.visible = false
	yesPainted.visible = true
	#paintTexture.material_override.texture = ResourceLoader.load(allTextures[paintID][1])
	#set in the singleton this paint to VANDALICED TRUE
	pass




