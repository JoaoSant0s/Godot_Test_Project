class_name PlayerCameraComponent extends Node

var currentCamera : VirtualCamera
@export var angular_vertical_speed : float = 5
@export var angular_horizontal_speed : float = 5

@export var flipHorizontalSign : bool
@export var flipVerticalSign : bool

@export var radiusModifier = 0.1

var input = Vector3.ZERO
var zoom : float

func process_camera(player : Player, delta : float):
	if not currentCamera:
		return
	
	input = Vector3.ZERO
	
	var horizontalSign = -1 if flipHorizontalSign else 1	
	var verticalSign = -1 if flipVerticalSign else 1
	
	var zoo
	
	input.x = Input.get_axis("horizontal_left", "horizontal_right") * horizontalSign * angular_horizontal_speed
	input.z = Input.get_axis("vertical_up", "vertical_down") * verticalSign * angular_vertical_speed
	zoom = Input.get_axis("zoom_in", "zoom_out")	

	input *= delta
	
	if input.x != 0:
		currentCamera.tracking.increment_horizontal_axis_value(input.x)

	if input.z != 0:
		currentCamera.tracking.increment_vertical_axis_value(input.z)
		
	if Input.is_action_just_released("zoom_in"):
		currentCamera.tracking.increment_radius(-radiusModifier)
		
	if Input.is_action_just_released("zoom_out"):
		currentCamera.tracking.increment_radius(radiusModifier)
	
func set_camera(virtualCamera : VirtualCamera):
	currentCamera = virtualCamera
	
func clean():
	currentCamera = null
