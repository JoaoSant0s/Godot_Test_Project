class_name Player extends CharacterBody3D

@export var inputComponent : PlayerInputComponent
@export var movementComponent : PlayerMovementComponent
@export var visionArea : MeshInstance3D

func _physics_process(delta):
	inputComponent.process_input()
	movementComponent.process_move(self, delta)
