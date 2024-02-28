class_name LinearTransitionSimulator extends CameraTransitionSimulator

var timePercentage : float

func buildTimePercentage():
	var duration = _getDefaultDuration()
	timePercentage = timedElapsed / duration
	timePercentage = min(1, timePercentage)
	
func preUpdate(delta : float):
	buildTimePercentage()

func getPosition(delta : float) -> Vector3:
	var nextPosition = _nextCamera.global_position
	
	if _previousCamera == null: return nextPosition
	if delta < 0: return _previousCamera.global_position

	if timePercentage >= 1: return nextPosition
	
	return _previousCamera.global_position.lerp(nextPosition, timePercentage)

func getRotation(delta : float) -> Vector3:
	var nextRotation = _nextCamera.global_rotation

	if _previousCamera == null: return nextRotation
	if delta < 0: return _previousCamera.global_rotation
	
	if timePercentage >= 1: return nextRotation

	return _previousCamera.global_rotation.lerp(nextRotation, timePercentage)
