class_name PlatformTriggerFixedFollow extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.target = player
	virtualCamera.tracking.lookAt = player
