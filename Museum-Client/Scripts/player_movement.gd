extends CharacterBody3D


const SPEED = 9.0
const JUMP_VELOCITY = 5
var MOUSE_SENSITIVITY = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var myID

#@export var camera: Camera3D
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
@onready var redball = $RedBall
@onready var isLabel = $Camera3D/Control/handcuffedLabel
@onready var hasLabel = $Camera3D/Control/hasHandcuffLabel


#--player variables--
var hasHandcuffs = true
var isHandcuffed = false
var badGuy = true #set randomlly at the beggining

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
func _ready():
	
	#????????
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		myID = multiplayer.get_unique_id()
		camera.current = true
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	redball.visible = false
	
func _physics_process(delta):
	
	#print("-", $MultiplayerSynchronizer.get_multiplayer_authority(), " ", multiplayer.get_unique_id())
	#is this multiplayer authority (input is from this player)
	#if $MultiplayerSynchronizer.get_multiplayer_authority() == myID && !isHandcuffed:
	isLabel.text = ("is_handcuffed "+ str(isHandcuffed) )
	hasLabel.text = ("has_handcuffs "+ str(hasHandcuffs) )
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() && !isHandcuffed:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()

func _input(event):

	if Input.is_action_just_pressed("ui_quit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	elif event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x) * MOUSE_SENSITIVITY)
		camera.rotate_x(-deg_to_rad(event.relative.y) * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	elif Input.is_action_just_pressed("ui_handcuffs"):
		if hasHandcuffs and raycast.is_colliding(): #player layer -> 1
			var hit_player = raycast.get_collider()
			if hit_player is Paint: return
			print(hit_player.get_name())
			hit_player.get_handcuffed.rpc_id(hit_player.get_name().to_int()) #multiplayer.get_unique_id()
			#print(hit_player.get_multiplayer_authority())
			hasHandcuffs = false
		
	elif Input.is_action_just_pressed("ui_paint"):
		if badGuy and raycast.is_colliding(): #cuadro layer -> 2
			#play animation 2-4 segs
			
			var detected = raycast.get_collider()
			if detected is Paint:
				print("player_movement -", "VANDALIZEE")
				detected.VandalicePainting.rpc()
			

@rpc("any_peer")
func get_handcuffed():
	isHandcuffed = true
	hasHandcuffs = false
	
	#show handcuff icon/animation
	redball.visible = true
	print("Im handcuffed ", multiplayer.get_unique_id())
	
	
