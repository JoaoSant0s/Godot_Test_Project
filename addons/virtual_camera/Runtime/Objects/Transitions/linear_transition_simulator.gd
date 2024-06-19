class_name LinearTransitionSimulator extends CameraTransitionSimulator

var timePercentage : float

func build_time_percentage():
	var duration = _get_default_duration()
	timePercentage = timedElapsed / duration
	timePercentage = min(1, timePercentage)
	
func pre_update(delta : float):
	build_time_percentage()

func get_fov(delta : float) -> float:
	var nextFov = _nextCamera.lens.fov if _nextCamera.lens else 75
	var previousFov = _previousCamera.lens.fov if _previousCamera.lens else 75
	
	if _previousCamera == null: return nextFov
	if delta < 0: return previousFov
	
	if timePercentage >= 1: return nextFov
	
	return lerp(previousFov, nextFov, timePercentage)
	
func get_position(delta : float) -> Vector3:
	var nextPosition = _nextCamera.global_position
	
	if _previousCamera == null: return nextPosition
	if delta < 0: return _previousCamera.global_position

	if timePercentage >= 1: return nextPosition
	
	return _previousCamera.global_position.lerp(nextPosition, timePercentage)

func get_rotation(delta : float) -> Vector3:
	var nextRotation = _nextCamera.global_rotation

	if _previousCamera == null: return nextRotation
	if delta < 0: return _previousCamera.global_rotation
	
	if timePercentage >= 1: return nextRotation

	return _previousCamera.global_rotation.lerp(nextRotation, timePercentage)
