extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 5
var MOUSE_SENSITIVITY = 0.5
const HANDCUFFS_OPACITY = 0.3 #between 1.0 and 0.0 invisible

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var myID
var syncPos = Vector3(0, 0, 0)
var syncRot = 0


#@export var camera: Camera3D
@onready var camera = $CameraPos/Camera3D
@onready var raycast = $CameraPos/Camera3D/RayCast3D
@onready var spray = $CameraPos/Camera3D/GPUParticles3D
@onready var redball = $RedBall
@onready var isLabel = $CameraPos/Camera3D/Control/handcuffedLabel
@onready var hasLabel = $CameraPos/Camera3D/Control/hasHandcuffLabel
@onready var roleLabel = $CameraPos/Camera3D/Control/roleLabel
@onready var endLabel = $CameraPos/Camera3D/Control/endGameLabel

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
#@onready var animation_mode = animation_tree.get("parameters/playback")

@onready var headRotation = $Armature/Skeleton3D/Cuerpo/HeadRotation
#@onready var headRotation = $CollisionShape3D/catcop_v1/metarig/Skeleton3D/HeadRotation

#--player variables--
var hasHandcuffs = true
var isHandcuffed = false
var badGuy #= false #set randomlly at the beggining
var canMove = true
var emote = false

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	
func _ready():
	
	#????????
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		myID = multiplayer.get_unique_id()
		camera.current = true
		
		#ocultar cuerpo
		$Armature/Skeleton3D/Cuerpo.visible = false
		$"Armature/Skeleton3D/Pierna Der".visible = false
		$"Armature/Skeleton3D/Pierna Izq".visible = false
		#headRotation.visible = false
		
		state_machine.start("Idle")
		
		
		#start voice capture
		$AudioManager.setupAudio(multiplayer.get_unique_id())
	
	setBadGuy(GameManager.Players[(str(self.name)).to_int()].badguy)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	redball.visible = false
	
func _physics_process(delta):
	
	#print("-", $MultiplayerSynchronizer.get_multiplayer_authority(), " ", multiplayer.get_unique_id())
	#is this multiplayer authority (input is from this player)
	#if $MultiplayerSynchronizer.get_multiplayer_authority() == myID && !isHandcuffed:
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		
		isLabel.text = ("is_handcuffed "+ str(isHandcuffed) )
		hasLabel.text = ("has_handcuffs "+ str(hasHandcuffs) )
		#$Camera3D/Control/HandcuffsTexture.visible = hasHandcuffs
		
		if isHandcuffed || !canMove:
			return
		
		headRotation.rotation.x = -camera.rotation.x #head movement
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
	
		## Handle jump.
		#if Input.is_action_just_pressed("ui_jump") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
		
		#BORRAR/CAMBIAR
		
		if Input.is_action_pressed("gesture1"):
			emote = true
			playAnim.rpc("Wave")
		elif  Input.is_action_pressed("gesture2"):
			emote = true
			playAnim.rpc("Point")
		elif  Input.is_action_pressed("gesture3"):
			emote = true
			playAnim.rpc("Dance02")
		else:
			emote = false
		
		syncPos = global_position
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if input_dir.y < 0 || input_dir.x != 0:
			playAnim.rpc("Walk")
		elif input_dir.y > 0:
			playAnim.rpc("WalkBack")
		elif !emote:
			playAnim.rpc("Idle")
			
		if direction: #is moving
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		
		
		move_and_slide()
	
	else:
		syncPos = global_position.lerp(syncPos, 0.5)
		

func _input(event):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
		
	if Input.is_action_just_pressed("ui_quit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	elif event is InputEventMouseMotion:
		
		#if !canMove: #block camera movement when spraying
			#return
		#event = event.make_input_local()
		if isHandcuffed:
			$CameraPos.rotate_y(-deg_to_rad(event.relative.x) * MOUSE_SENSITIVITY)
		else:
			rotate_y(-deg_to_rad(event.relative.x) * MOUSE_SENSITIVITY)
		camera.rotate_x(-deg_to_rad(event.relative.y) * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2 +.3, PI/2)
		
		
		
	
	elif Input.is_action_just_pressed("ui_handcuffs"):
		if hasHandcuffs and raycast.is_colliding(): #player layer -> 1
			
			var hit_player = raycast.get_collider()
			if hit_player is Paint:
				return
			else:
				playAnim.rpc("putHandcuffsNew")
				print(hit_player.get_name())
				hit_player.get_handcuffed.rpc_id(hit_player.get_name().to_int()) #multiplayer.get_unique_id()
				#print(hit_player.get_multiplayer_authority())
				hasHandcuffs = false
				
				#$Camera3D/Control/HandcuffsTexture.modulate.a = HANDCUFFS_OPACITY
		
	elif Input.is_action_just_pressed("ui_paint"):
		if badGuy and raycast.is_colliding(): #cuadro layer -> 2
			
			var detected = raycast.get_collider()
			if detected is Paint && !detected.vandalized:
				#play animation 4 segs
				#playAnim.rpc("Paint")
				SprayPainting()
				print("player_movement -", "VANDALIZE")
				detected.VandalicePainting.rpc()
				if CountVandalized():
					VandalsWin.rpc()
			

@rpc("any_peer", "call_remote")
func get_handcuffed():
	
	isHandcuffed = true
	hasHandcuffs = false
	
	#show handcuff icon/animation
	#headRotation.visible = true
	$Armature/Skeleton3D/Cuerpo.visible = true
	$"Armature/Skeleton3D/Pierna Der".visible = true
	$"Armature/Skeleton3D/Pierna Izq".visible = true
	#redball.visible = true
	print("Im handcuffed ", multiplayer.get_unique_id())
	GameManager.HandCuffPlayer.rpc((str(self.name)).to_int()) #update handcuffed
	camera.position = $CameraHandcuffed.position
	playAnim.rpc("Handcuffed02")
	headRotation.rotation.x = 0
	#playAnim.rpc("Handcuffed02")
	
	var badGuysLeft = false
	for i in GameManager.Players:
		if GameManager.Players[i].badguy && !GameManager.Players[i].handcuffed: #badguy without handcuffs
			badGuysLeft = true
	
	if !badGuysLeft:
		GuardsWin.rpc()


func setBadGuy(role):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		badGuy = role
		print("setBadGuy ",myID, role)
		roleLabel.text = ""
		if role:
			roleLabel.text = "you are a VANDAL"
		else:
			roleLabel.text = " you are a GUARD"

@rpc("any_peer", "call_local", "reliable")
func VandalsWin():
	endLabel.text = ("VANDALS WIN! /n all paintings were vandalized")

@rpc("any_peer","call_local", "reliable")
func  GuardsWin():
	endLabel.text = ("GUARDS WIN /n all vandals were cought")

func CountVandalized():
	var countVandalized = 0
	for i in GameManager.Paintings:
		if GameManager.Paintings[i].isVandalized == true:
			countVandalized += 1
	
	#contar cauntos cuadros han sido vandalizados
	if countVandalized >= GameManager.Paintings.size():
		return true
	return false

#animations
@rpc("any_peer", "call_local")
func playAnim(animationName):
	state_machine.travel(animationName)
	
func callHandcuffedAnim():
	playAnim.rpc("Handcuffed02")

func BlockMovement():
	headRotation.rotation.x = 0
	canMove = false


func ActivateMovement():
	canMove = true
	spray.emitting = false

func SprayPainting():
	headRotation.rotation.x = 0
	canMove = false
	spray.emitting = true
	$CameraPos/Camera3D/GPUParticles3D/SprayTimer.start()

func _on_spray_timer_timeout():
	canMove = true
	spray.emitting = false

