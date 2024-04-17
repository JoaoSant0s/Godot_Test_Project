class_name PlayerCameraComponent extends Node

var currentCamera : VirtualCamera
@export var angular_spedd : float
var input = Vector3.ZERO

func process_camera(player : Player, delta : float):
	if not currentCamera:
		return
	
	input = Vector3.ZERO
	
	input.x = Input.get_axis("horizontal_left", "horizontal_right")
	input.z = Input.get_axis("vertical_up", "vertical_down")
	input = input.normalized()
	input *= angular_spedd * delta
	
	if input.x != 0:
		currentCamera.tracking.increment_horizontal_axis_value(input.x)

	if input.z != 0:
		currentCamera.tracking.increment_vertical_axis_value(input.z)
	
func set_camera(virtualCamera : VirtualCamera):
	currentCamera = virtualCamera
	
func clean():
	currentCamera = null
