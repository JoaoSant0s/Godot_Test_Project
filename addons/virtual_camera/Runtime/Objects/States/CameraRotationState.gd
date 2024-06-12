class_name CameraRotationState

var mainCamera : MainCamera

func _init(_mainCamera: MainCamera):
	mainCamera = _mainCamera

func update(delta : float):
	var tracking = mainCamera.currentVirtualCamera.tracking
	var global_rotation : Vector3
	if not tracking.lookAt:
		mainCamera.cameraSimulator.build_rotation()
		global_rotation = mainCamera.cameraSimulator.get_rotation(delta)
	else:
		var targetPosition : Vector3 = tracking.lookAt.global_position + tracking.get_follow_offset()
		var cameraPosition : Vector3 = mainCamera.global_position
		var lookDirection = (targetPosition - cameraPosition).normalized()
		
		global_rotation = MathCameras.normilized_direction_to_decomposed_axis_angle(lookDirection)
		mainCamera.currentVirtualCamera.global_rotation = global_rotation		

	mainCamera.global_rotation = global_rotation
