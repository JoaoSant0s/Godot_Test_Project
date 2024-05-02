class_name Player extends CharacterBody3D

@export var inputComponent : PlayerInputComponent
@export var movementComponent : PlayerMovementComponent
@export var cameraComponent : PlayerCameraComponent

@export var visionArea : MeshInstance3D
@export var center : Node3D

func _physics_process(delta):
	inputComponent.process_input()
	movementComponent.process_move(self, delta)
	cameraComponent.process_camera(delta)

func set_camera(virtualCamera : VirtualCamera):
	cameraComponent.set_camera(virtualCamera)

func clean_camera():
	cameraComponent.clean()
