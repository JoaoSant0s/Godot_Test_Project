class_name PlayerCameraComponent extends Node

var currentCamera : VirtualCamera
@export var angular_vertical_speed : float = 5
@export var angular_horizontal_speed : float = 5

@export var flipHorizontalSign : bool
@export var flipVerticalSign : bool

@export var radiusModifier = 0.1
@export var maxZoom = 3
@export var minZoom = 1

var camera_input = Vector3.ZERO
var zoom = 0.0

func process_camera(player : Player, delta : float):
	if not currentCamera:
		return
	
	camera_input = player.inputComponent.camera_input
	
	var horizontalSign = -1 if flipHorizontalSign else 1	
	var verticalSign = -1 if flipVerticalSign else 1
	
	camera_input.x = camera_input.x * horizontalSign * angular_horizontal_speed
	camera_input.z = camera_input.z * verticalSign * angular_vertical_speed
	camera_input *= delta
	
	if camera_input.x != 0:
		currentCamera.tracking.increment_horizontal_axis_value(camera_input.x)

	if camera_input.z != 0:
		currentCamera.tracking.increment_vertical_axis_value(camera_input.z)

	zoom = radiusModifier * player.inputComponent.zoom * delta	
	var radius = currentCamera.tracking.radius
	if (zoom < 0 and radius > minZoom) or (zoom > 0 and radius < maxZoom):
		currentCamera.tracking.increment_radius(zoom)
		
func set_camera(virtualCamera : VirtualCamera):
	currentCamera = virtualCamera
	
func clean():
	currentCamera = null
