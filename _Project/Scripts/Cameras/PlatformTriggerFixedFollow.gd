class_name PlatformTriggerFixedFollow extends PlatformTrigger

func _playerTriggered(player : Player):
	virtualCamera.tracking.target = player
	virtualCamera.tracking.lookAt = player
