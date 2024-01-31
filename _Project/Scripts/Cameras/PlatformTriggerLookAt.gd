class_name PlatformTriggerLookAt extends PlatformTrigger

func _playerTriggered(player : Player):
	virtualCamera.tracking.lookAt = player	
