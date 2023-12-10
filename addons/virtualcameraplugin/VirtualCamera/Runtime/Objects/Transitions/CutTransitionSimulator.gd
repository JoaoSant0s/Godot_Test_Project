class_name CutTransitionSimulator extends CameraTransitionSimulator

func getPosition(delta : float) -> Vector3:
	return _nextCamera.global_position

func getRotation(delta : float) -> Vector3:
	return _nextCamera.global_rotation
