class_name CutTransitionSimulator extends CameraTransitionSimulator

func get_position(delta : float) -> Vector3:
	return _next_camera.global_position

func get_rotation(delta : float) -> Vector3:
	return _next_camera.global_rotation

func get_fov(delta : float) -> float:
	if not _next_camera.lens:
		return 75
	return _next_camera.lens.fov
