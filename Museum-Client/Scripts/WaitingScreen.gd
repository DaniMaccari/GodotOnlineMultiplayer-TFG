extends Control

var numPlayers = 0
var waitTimer
var totalWaitTime
# Called when the node enters the scene tree for the first time.
func _ready():
	waitTimer = $WaitingTimer
	waitTimer.start()
	##totalWaitTime = 30
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_waiting_timer_timeout():
	numPlayers = GameManager.Players.size()
	#totalWaitTime -= 1
	
	print("READING PLAYERSSS")
	$VBoxContainer/NumPlayersLabel.text = (str(numPlayers)+ "/8 players")
	pass # Replace with function body.
