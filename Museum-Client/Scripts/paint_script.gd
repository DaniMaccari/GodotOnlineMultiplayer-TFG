class_name Paint
extends StaticBody3D

var allTextures = [
#    original                              ,   vandaliced 
	["res://paintTextures/paintTest_1a.png", "res://paintTextures/paintTest_1b.png"],
	["res://paintTextures/paintTest_2a.png", "res://paintTextures/paintTest_2b.png"]
]

@export var paintTexture : MeshInstance3D
var paintID : int
var frameRate = 10/1
var vandalized = false
@onready var notPainted : MeshInstance3D = $CollisionShape3D/pintura0
@onready var yesPainted : MeshInstance3D = $CollisionShape3D/pintura1

func _ready():
	
	paintID = 1 #number added when games start
	#$MultiplayerSynchronizer.set_multiplayer_authority( 9000 + paintID)
	
	notPainted.visible = true
	yesPainted.visible = false
	#paintTexture.material_override.set_texture(allTextures[paintID][0])

func _process(delta):
	
	#if is_multiplayer_authority() && vandalized:
	#if $MultiplayerSynchronizer.get_multiplayer_authority() == 1 && vandalized:
	if vandalized:
		notPainted.visible = false
		yesPainted.visible = true


@rpc("any_peer", "call_local")
func VandalicePainting():
	print("paint_script -", "PAINTINGG")
	vandalized = true
	GameManager.Paintings[str(self.name)].isVandalized = true
	
	var countVandalized = 0
	for i in GameManager.Paintings:
		if GameManager.Paintings[i].isVandalized == true:
			countVandalized += 1
	
	#contar cauntos cuadros han sido vandalizados
	if countVandalized >= GameManager.Paintings.size():
		#VANDALS WIN
		print("VANDALS WIN game over")
		#GameManager.CallVandalsWin()








