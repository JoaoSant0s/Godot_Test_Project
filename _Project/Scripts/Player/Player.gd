class_name Player extends CharacterBody3D

@export var movementComponent : PlayerMovementComponent
@export var visionArea : MeshInstance3D

func _physics_process(delta):
	movementComponent.move(self, delta)
