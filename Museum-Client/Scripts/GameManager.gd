extends Node

var Players = {} #dictionary
var max_players = 8
#"name": nickName,
#"id": id,
#"score": 0,
#"badguy": false,
#"handcuffed": false
var Paintings = {}
var numPaintings = 0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func selectBadGuys():
	#selec unmber of badguys
	var numPlayers = Players.size()
	var numBadGuys = 2
	var badGuysPos = [-1, -1, -1]
	if numPlayers <= 4: #if less than 6 players 1 badguy
		numBadGuys -= 1
	
	var rng = RandomNumberGenerator.new()
	while numBadGuys > 0:
		var setRandom = rng.randi_range(0, numPlayers -1)
		
		if badGuysPos[0] == -1:
			badGuysPos[0] = setRandom
			numBadGuys -= 1
		elif badGuysPos[0] != setRandom:
			badGuysPos[1] = setRandom
			numBadGuys -=1
	print(badGuysPos)
	var playerCounter = 0
	#send info to all players
	for player in Players:
		if playerCounter == badGuysPos[numBadGuys]:
			setBadGuyDictionary.rpc(player)
			numBadGuys += 1
		playerCounter += 1

	print(Players)

@rpc("any_peer", "call_local")
func setBadGuyDictionary(thisPlayer):
	Players[thisPlayer].badguy = true
	print(Players[thisPlayer])
	pass

@rpc("any_peer", "call_local")
func HandCuffPlayer(playerID):
	Players[playerID].handcuffed = true

#func CallVandalsWin():
	#
	#for i in Players:
		#Players[i]
		
		

