class_name PlatformTrigger extends Node

@export var collisionArea : Area3D
@export var virtualCamera : VirtualCamera

func _ready():
	collisionArea.body_entered.connect(_trigger_platform)

func _player_triggered(_player : Player):
	pass

func _trigger_platform(body : Node3D):
	if not body.is_in_group("Player"): return
	if virtualCamera.is_active_camera():
		return

	_player_triggered(body as Player)
	virtualCamera.force_active_camera()

func _exit_tree():
	collisionArea.body_entered.disconnect(_trigger_platform)
	pass



