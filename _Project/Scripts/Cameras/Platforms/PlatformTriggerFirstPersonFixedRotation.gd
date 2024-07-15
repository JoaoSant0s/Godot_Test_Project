class_name PlatformTriggerFirstPersonFixedRotation extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.target = player.visionArea
