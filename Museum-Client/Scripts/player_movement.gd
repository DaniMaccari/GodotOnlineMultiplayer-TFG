extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 5
var MOUSE_SENSITIVITY = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var camera: Camera3D
#var camera: Camera3D
#@onready var camera = $Camera3D

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
func _ready():
	
	#????????
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.current = true
	#is_local_player = (multiplayer.get_network_master() == multiplayer.get_unique_id())

func _physics_process(delta):
	
	#is this multiplayer authority (input is from this player)
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		
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
	if camera == null:
		return
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-deg_to_rad(event.relative.x) * MOUSE_SENSITIVITY)
		camera.rotate_x(-deg_to_rad(event.relative.y) * MOUSE_SENSITIVITY)
		$CollisionShape3D/eyesPosition.rotate_x(camera.rotation.x)
