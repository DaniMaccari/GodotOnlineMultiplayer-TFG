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
	if numPlayers <= 5: #if less than 6 players 1 badguy
		numBadGuys -= 1
	
	var rng = RandomNumberGenerator.new()
	while numBadGuys > 0:
		var setRandom = rng.randi_range(0, numPlayers)
		if !Players[setRandom].badguy: #if not already badguy
			Players[setRandom].badguy = true
			numBadGuys -= 1
	
	#send info to all players
	for player in Players:
		rpc_id(player.id, "setBadGuy", player.badguy)
