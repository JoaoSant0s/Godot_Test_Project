extends CharacterBody3D
 
const SPEED = 5.0
const ANGULAR_SPEED = 0.1
const JUMP_VELOCITY = 4.5
 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
 
func _ready() -> void:
	pass
 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta
 
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
 
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var resetVelocity = false
	
	if input_dir:
		rotation.y -= input_dir.x * ANGULAR_SPEED
		if input_dir.y != 0:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			resetVelocity = true
	else:
		resetVelocity = true
	
	if resetVelocity:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
