class_name PlayerInputComponent extends Node

var isRunning : bool

var movement_input : Vector3
var camera_input : Vector3
var jumped : bool
var zoom : float

func process_input():
	movement_input = Vector3.ZERO
	movement_input.x = Input.get_axis("left", "right")
	movement_input.z = Input.get_axis("forward", "back")
	
	camera_input = Vector3.ZERO
	camera_input.x = Input.get_axis("horizontal_left", "horizontal_right")
	camera_input.z = Input.get_axis("vertical_up", "vertical_down")

	isRunning = Input.is_action_pressed("run")
	jumped = Input.is_action_just_pressed("jump")
	
	zoom = Input.get_axis("zoom_in", "zoom_out")
