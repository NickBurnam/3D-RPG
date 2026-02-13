extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Stores the X,Y direction the player is trying to look in
var _look:Vector2 = Vector2.ZERO

# Stores the direction the player moves when attacking
var _attack_direction:Vector3 = Vector3.ZERO

@export var mouse_sensitivity:float = 0.00075
@export var min_boundary:float = -60.0 #degrees
@export var max_boundary:float = 10.0 #degrees
@export var animation_decay:float = 20.0
@export var attack_move_speed:float = 3.0

@onready var smooth_camera_arm: SpringArm3D = $SmoothCameraArm
@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var rig_pivot: Node3D = $RigPivot
@onready var rig: Node3D = $RigPivot/Rig


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	frame_camera_rotation()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the direction of movement
	var direction := get_movement_direction()
	
	# Update the rig animation tree (idle vs moving)
	rig.update_animation_tree(direction)
	
	# Update the velocity of the player, update rig direction if needed
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Update the Rig to face the direction of movement
		look_toward_direction(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	handle_slashing_physics_frame(delta)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_look += -event.relative * mouse_sensitivity
	if rig.is_idle():
		if event.is_action_pressed("click"):
			slash_attack()


func get_movement_direction() -> Vector3:
	# Get the player movement vector
	var input_dir:Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Normalize the X and Y input components and make a Vector3
	var input_vector:Vector3 = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	# Multiply the basis of the horizontal pivot to our input vector
	return horizontal_pivot.global_transform.basis * input_vector

func frame_camera_rotation() -> void:
	# Rotate about the Y axis (vertical) -> look left and right
	horizontal_pivot.rotate_y(_look.x)
	
	# Rotate about the X axis (horizontal) -> look up and down
	vertical_pivot.rotate_x(_look.y)
	
	# Clamp up and down camera rotation to avoid going upside down
	vertical_pivot.rotation.x = clampf(vertical_pivot.rotation.x,deg_to_rad(min_boundary),deg_to_rad(max_boundary))
	
	# Apply the result to the spring arm
	#spring_arm_3d.global_transform = vertical_pivot.global_transform
	
	# Reset the _look vector for the next calculation
	_look = Vector2.ZERO


func look_toward_direction(direction:Vector3, delta:float) -> void:
	# +Z axis is front, use looking_at() to calculate the new transform
	var target_transform:Transform3D = rig_pivot.global_transform.looking_at(rig_pivot.global_position + direction, Vector3.UP, true)
	
	# Interpolate to the target transform using exp decay function: 1.0 - exp(-decay * delta)
	rig_pivot.global_transform = rig_pivot.global_transform.interpolate_with(target_transform, 1.0 - exp(-animation_decay * delta))


func slash_attack() -> void:
	rig.travel("Slash")
	_attack_direction = get_movement_direction()
	
	# When there is no movement, use the current facing direction
	if _attack_direction.is_zero_approx():
		# Rig is facing +z axis
		_attack_direction = rig.global_basis * Vector3(0,0,1)


func handle_slashing_physics_frame(delta:float) -> void:
	if not rig.is_slashing():
		return
	
	# Update the velocity with the attack speed value in the attack direction
	velocity.x = _attack_direction.x * attack_move_speed
	velocity.z = _attack_direction.z * attack_move_speed
	
	# Face the rig to the attack direction
	look_toward_direction(_attack_direction, delta)
