class_name PlatformTriggerFixedFollow extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.target = player.center
	virtualCamera.tracking.lookAt = player.center
