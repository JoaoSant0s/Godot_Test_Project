class_name PlatformTriggerOrbital extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.target = player.center
	virtualCamera.tracking.lookAt = player.center
	
	player.set_camera(virtualCamera)
