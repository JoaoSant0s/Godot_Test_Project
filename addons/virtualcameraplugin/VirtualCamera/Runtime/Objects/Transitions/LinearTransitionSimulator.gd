class_name LinearTransitionSimulator extends CameraTransitionSimulator

var timedElapsed : float = 0

func getPosition(delta : float) -> Vector3:
	if _previousCamera == null: return _nextCamera.global_position
	if delta < 0: return _previousCamera.global_position
	
	var duration = _getDefaultDuration()
	var timePercentage : float = timedElapsed / duration	
	if timePercentage >= 1: return _nextCamera.global_position
	
	var position = _previousCamera.global_position.lerp(_nextCamera.global_position, timePercentage)
	print(timePercentage, " ", position, " ", delta)
	timedElapsed += delta
	
	return position

func getRotation(delta : float) -> Vector3:
	if _previousCamera == null: return _nextCamera.global_rotation
	if delta < 0: return _previousCamera.global_rotation
	
	# TODO Implemented
	
	return _nextCamera.global_rotation
