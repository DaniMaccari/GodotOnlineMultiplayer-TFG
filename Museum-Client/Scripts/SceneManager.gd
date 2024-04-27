extends Node3D

@export var PlayerScene : PackedScene
@export var PaintingScene : PackedScene

func _ready():
	SpawnPaintings()
	SpawnPlayers()

func SpawnPlayers():
	
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("SpawnLocationPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
				#currentPlayer.setBadGuy(GameManager.Players[i].badguy)
		index += 1

func SpawnPaintings():
	
	var index = 0
	for i in get_tree().get_nodes_in_group("PaintLocationPoint"):
		print(str(i.name))
		if !GameManager.Paintings.has(str(i.name)):
			GameManager.Paintings[str(i.name)] = {
				"isVandalized" = false
			}
	GameManager.numPaintings = GameManager.Paintings.size()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass







