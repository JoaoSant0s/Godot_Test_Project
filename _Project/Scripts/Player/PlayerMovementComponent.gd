class_name PlayerMovementComponent extends Node
 
@export_subgroup("Components")
@export var model : Node3D
@export var animation : AnimationPlayer

@export_subgroup("Properties")
@export var movement_speed = 250
@export var angular_speed = 0.15
@export var run_speed = 500
@export var jump_strength = 8

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true
var input : Vector3
	
func process_move(player : Player, delta : float):
	var speed = _handle_controls(player, delta)
	_handle_gravity(player, delta)
	_handle_animations(player, speed)

	_update_rotation(player, delta)
	_update_movement(player, delta, speed)
	_update_animation(player, delta)

func _handle_controls(player: Player, delta : float) -> int:
	input = -player.inputComponent.movement_input
	var speed = run_speed if player.inputComponent.isRunning else movement_speed
	if input == Vector3.ZERO:
		speed = 0

	movement_velocity = (player.basis * input * -1).normalized() * speed * delta
	
	if player.inputComponent.jumped:
		if jump_double:
			gravity = -jump_strength
			
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)
			
		if(jump_single): jump()
	return speed

func _handle_gravity(player : Player, delta):
	gravity += 25 * delta
	
	if gravity > 0 and player.is_on_floor():
		
		jump_single = true
		gravity = 0

func _handle_animations(player : Player, speed : float):
	if player.is_on_floor():
		if abs(player.velocity.x) > 1 or abs(player.velocity.z) > 1:
			animation.play("walk", -1, speed / movement_speed)
		else:
			animation.play("idle", 0.5)
	else:
		animation.play("jump", 0.5)

func _update_rotation(player : Player, delta : float):
	if input == Vector3.ZERO:
		return

	var camera = _try_get_virtual_camera(player)
	if camera:
		rotation_direction = atan2(input.x, input.z) + deg_to_rad(camera.tracking.horizontal_axis_value)
		player.rotation.y = lerp_angle(player.rotation.y, rotation_direction, delta * angular_speed)
	else:
		player.rotation.y += input.x * angular_speed * delta

func _update_movement(player : Player, delta : float, speed : float):
	var camera = _try_get_virtual_camera(player)
	var applied_velocity: Vector3
	
	if camera:
		var targetDirection = Vector3.FORWARD.rotated(Vector3.UP, rotation_direction)
		applied_velocity = targetDirection.normalized() * speed * delta
	else:
		applied_velocity = player.velocity.lerp(movement_velocity, delta * 10)
		
	applied_velocity.y = -gravity
	player.velocity = applied_velocity

	player.move_and_slide()

func _try_get_virtual_camera(player : Player) -> VirtualCamera:
	return player.cameraComponent.currentCamera
	
func _update_animation(player : Player, delta : float):
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	if player.is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
	
	previously_floored = player.is_on_floor()

func jump():
	gravity = -jump_strength

	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false;
	jump_double = true;
