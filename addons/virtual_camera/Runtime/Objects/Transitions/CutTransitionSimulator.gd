class_name CutTransitionSimulator extends CameraTransitionSimulator

func get_position(delta : float) -> Vector3:
	return _nextCamera.global_position

func get_rotation(delta : float) -> Vector3:
	return _nextCamera.global_rotation

func get_fov(delta : float) -> float:
	if not _nextCamera.lens:
		return 75
	return _nextCamera.lens.fov
