class_name CameraCutSimulator extends CameraTransitionSimulator

func getPosition(delta : float) -> Vector3:
	var position : Vector3

	if _nextCamera.tracking.target:
		_nextCamera.global_position = _nextCamera.tracking.target.global_position
	
	position = _nextCamera.global_position
		
	return position

