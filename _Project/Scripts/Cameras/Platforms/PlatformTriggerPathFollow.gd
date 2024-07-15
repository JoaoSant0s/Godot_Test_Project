class_name PlatformTriggerPathFollow extends PlatformTrigger

func _player_triggered(player : Player):
	#virtualCamera.tracking.target = player
	#virtualCamera.tracking.look_at = player.center
	pass
