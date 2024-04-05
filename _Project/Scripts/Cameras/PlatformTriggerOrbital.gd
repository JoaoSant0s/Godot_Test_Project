class_name PlatformTriggerOrbital extends PlatformTrigger

func _player_triggered(player : Player):
	# TODO: Must implement a version here
	virtualCamera.tracking.target = player
	virtualCamera.tracking.lookAt = player
