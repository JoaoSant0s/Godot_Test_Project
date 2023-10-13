class_name PlatformTrigger extends Node

@export var collisionArea : Area3D
@export var virtualCamera : VirtualCamera

func _ready():
	collisionArea.body_entered.connect(_trigger_platform)

func _trigger_platform(body : Node3D):
	if not body.is_in_group("Player"): return
	
	if virtualCamera.isActiveCamera(): return
	
	if virtualCamera.enabled:
		virtualCamera.priority += 1
	else:
		virtualCamera.enabled = true

func _exit_tree():
	collisionArea.body_entered.disconnect(_trigger_platform)
	pass
