extends HBoxContainer

var myIp : String
signal joinGame(ip)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ChangeIp(newIp):
	print("ipRecieved: ", newIp)
	if newIp == "":
		$ButtonJoin.disabled = true
	else:
		myIp = newIp
		$ButtonJoin.disabled = false

func _on_button_join_pressed():
	print("ipJoined: ", myIp)
	joinGame.emit(myIp)

