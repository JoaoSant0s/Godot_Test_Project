class_name PlatformTriggerLookAt extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.look_at = player	
