extends Node

var Players = {}

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func selectBadGuys():
	#selec unmber of badguys
	var numPlayers = Players.size()
	var numBadGuys = 2
	var badGuysPos = [-1, -1]
	if numPlayers <= 5: #if less than 6 players 1 badguy
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
			Players[player].badguy = true
			print(Players[player])
		#rpc_id(Players[player].id, "setBadGuy", Players[player].badguy)
