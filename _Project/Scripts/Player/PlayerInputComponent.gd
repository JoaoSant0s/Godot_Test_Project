class_name PlayerInputComponent extends Node

var isRunning : bool
var input : Vector3
var jumped : bool

func process_input(player : Player, delta : float):
	input = Vector3.ZERO
	
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("forward", "back")
	input = input.normalized()

	isRunning = Input.is_action_pressed("run")
	jumped = Input.is_action_just_pressed("jump")
