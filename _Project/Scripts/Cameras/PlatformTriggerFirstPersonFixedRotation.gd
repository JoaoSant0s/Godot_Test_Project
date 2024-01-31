class_name PlatformTriggerFirstPersonFixedRotation extends PlatformTrigger

func _playerTriggered(player : Player):
	virtualCamera.tracking.target = player.visionArea
