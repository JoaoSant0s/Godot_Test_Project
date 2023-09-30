extends Node2D

@export_subgroup("Properties")
@export var movementSpeed : float

@export_subgroup("Movement")
@export var leftMovement : Key
@export var rightMovement : Key

const directionZero = Vector2.ZERO

const angular_speed = PI
func _process(delta):
	rotateAction(delta)
	
	moveAction(delta)

func rotateAction(delta):
	rotation  += angular_speed * delta
	
func moveAction(delta):
	var direction = Vector2.ZERO;	
	
	if Input.is_key_pressed(leftMovement):
		direction = Vector2.LEFT
	elif Input.is_key_pressed(rightMovement):
		direction = Vector2.RIGHT
	
	if direction == directionZero: return
		
	position += direction * movementSpeed * delta
