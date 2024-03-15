extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 4.5
var MOUSE_SENSITIVITY = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

 
@onready var camera = $Camera3D
@onready var synchronizer = $MultiplayerSynchronizer

func _ready():
	synchronizer.set_multiplayer_authority(str(name).to_int())
	camera.current = synchronizer.is_multiplayer_authority()

func _physics_process(delta):
	# Add the gravity.
	if is_multiplayer_authority():
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
	if synchronizer.is_multiplayer_authority():
		if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-deg_to_rad(event.relative.x) * MOUSE_SENSITIVITY)
			synchronizer.y_rotation = rotation.y
			camera.rotate_x(-deg_to_rad(event.relative.y) * MOUSE_SENSITIVITY)
