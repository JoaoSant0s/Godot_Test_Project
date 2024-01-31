class_name PlayerMovementComponent extends Node
 
@export_subgroup("Components")
@export var view: Node3D
@export var model : Node3D
@export var animation : AnimationPlayer

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 7

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

# Functions
func move(player : Player, delta : float):
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(player, delta)
	
	handle_effects(player)
	
	# Movement

	var applied_velocity: Vector3
	
	applied_velocity = player.velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	player.velocity = applied_velocity
	player.move_and_slide()
	
	# Rotation
	
	if Vector2(player.velocity.z, player.velocity.x).length() > 0:
		rotation_direction = Vector2(player.velocity.z, player.velocity.x).angle()
		
	player.rotation.y = lerp_angle(player.rotation.y, rotation_direction, delta * 10)
	
	# Animation for scale (jumping and landing)
	
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# Animation when landing
	
	if player.is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
	
	previously_floored = player.is_on_floor()

# Handle animation(s)

func handle_effects(player : Player):
	if player.is_on_floor():
		if abs(player.velocity.x) > 1 or abs(player.velocity.z) > 1:
			animation.play("walk", 0.5)
			pass
		else:
			#animation.play("idle", 0.5)
			pass
	else:
		#animation.play("jump", 0.5)
		pass

# Handle movement input

func handle_controls(delta : float):
	# Movement
	
	var input := Vector3.ZERO
	
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("forward", "back")
	
	#input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	input = input.normalized()
	
	movement_velocity = input * movement_speed * delta
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		if jump_double:			
			gravity = -jump_strength
			
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)
			
		if(jump_single): jump()

# Handle gravity

func handle_gravity(player : Player, delta):
	gravity += 25 * delta
	
	if gravity > 0 and player.is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func jump():
	gravity = -jump_strength

	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false;
	jump_double = true;

#region Old Movement Method

#const SPEED = 5.0
#const ANGULAR_SPEED = 0.1
#const JUMP_VELOCITY = 4.5
 #
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
 #
#func _ready() -> void:
	#pass
#
#func move(player : Player, delta : float) -> void:
	## Add the gravity.	
	#var isFloor = player.is_on_floor()
	#
	#if not isFloor:
		#player.velocity.y -= gravity * delta
 #
	## Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and isFloor:
		#player.velocity.y = JUMP_VELOCITY
 #
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("left", "right", "forward", "back")
	#var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#
	#var resetVelocity = false
	#
	#if input_dir:
		#player.rotation.y -= input_dir.x * ANGULAR_SPEED
		#if input_dir.y != 0:
			#player.velocity.x = direction.x * SPEED
			#player.velocity.z = direction.z * SPEED
		#else:
			#resetVelocity = true
	#else:
		#resetVelocity = true
	#
	#if resetVelocity:
		#player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		#player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	#
	#player.move_and_slide()
#endregion
