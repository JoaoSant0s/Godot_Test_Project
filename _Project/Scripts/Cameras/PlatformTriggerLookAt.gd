class_name PlatformTriggerLookAt extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.lookAt = player	
