class_name PlatformTriggerOrbital extends PlatformTrigger

func _player_triggered(player : Player):
	virtualCamera.tracking.target = player.center
	virtualCamera.tracking.look_at = player.center
	
	player.set_camera(virtualCamera)
