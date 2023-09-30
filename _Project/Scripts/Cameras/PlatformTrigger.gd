class_name PlatformTrigger extends Node

@export var collisionArea : Area3D
@export var virtualCamera : VirtualCamera

var enterCallable = Callable(self, "_trigger_platform")

func _ready():
	collisionArea.body_entered.connect(enterCallable)

func _trigger_platform(body : Node3D):
	if not body.is_in_group("Player"): return
	
	print(body)	

func _exit_tree():
	collisionArea.body_entered.disconnect(enterCallable)
	pass
