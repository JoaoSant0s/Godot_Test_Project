class_name PlatformTriggerOrbital extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.target = player
	virtualCamera.tracking.lookAt = player
	
	player.set_camera(virtualCamera)
