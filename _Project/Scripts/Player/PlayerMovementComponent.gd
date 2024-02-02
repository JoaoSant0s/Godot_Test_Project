class_name PlayerMovementComponent extends Node
 
@export_subgroup("Components")
@export var model : Node3D
@export var animation : AnimationPlayer

@export_subgroup("Properties")
@export var movement_speed = 250
@export var run_speed = 500
@export var jump_strength = 8

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

func process_move(player : Player, delta : float):
	var speed = handle_controls(player, delta)
	handle_gravity(player, delta)
	handle_animations(player, speed)

	update_movement(player, delta)
	update_rotation(player, delta)
	update_animation(player, delta)

func update_movement(player : Player, delta : float):
	var applied_velocity: Vector3
	
	applied_velocity = player.velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	player.velocity = applied_velocity
	player.move_and_slide()

func update_rotation(player : Player, delta : float):
	if Vector2(player.velocity.z, player.velocity.x).length() > 0:
		rotation_direction = Vector2(player.velocity.z, player.velocity.x).angle()
	player.rotation.y = lerp_angle(player.rotation.y, rotation_direction, delta * 10)

func update_animation(player : Player, delta : float):
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# Animation when landing	
	if player.is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
	
	previously_floored = player.is_on_floor()
	
func handle_animations(player : Player, speed : int):
	if player.is_on_floor():
		if abs(player.velocity.x) > 1 or abs(player.velocity.z) > 1:
			animation.play("walk", 0.5, speed / movement_speed)
			pass
		else:
			animation.play("idle", 0.5)
			pass
	else:
		animation.play("jump", 0.5)
		pass

func handle_controls(player: Player, delta : float) -> int:
	var input = player.inputComponent.input
	
	var speed = run_speed if player.inputComponent.isRunning else movement_speed
	
	movement_velocity = input * speed * delta
	
	if player.inputComponent.jumped:
		if jump_double:			
			gravity = -jump_strength
			
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)
			
		if(jump_single): jump()
	return speed

func handle_gravity(player : Player, delta):
	gravity += 25 * delta
	
	if gravity > 0 and player.is_on_floor():
		
		jump_single = true
		gravity = 0

func jump():
	gravity = -jump_strength

	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false;
	jump_double = true;
