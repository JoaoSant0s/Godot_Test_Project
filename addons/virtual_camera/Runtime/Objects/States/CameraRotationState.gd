class_name CameraRotationState

var mainCamera : MainCamera

func _init(_mainCamera: MainCamera):
	mainCamera = _mainCamera

func update(delta : float):
	var tracking = mainCamera.currentVirtualCamera.tracking
	if not tracking.lookAt:
		mainCamera.cameraSimulator.build_rotation()
		mainCamera.global_rotation = mainCamera.cameraSimulator.get_rotation(delta)
	else:
		var targetPosition : Vector3 = tracking.lookAt.global_position + tracking.get_follow_offset()
		var cameraPosition : Vector3 = mainCamera.global_position
		var lookDirection = (targetPosition - cameraPosition).normalized()

		mainCamera.look_at(targetPosition)
		mainCamera.currentVirtualCamera.global_rotation = mainCamera.global_rotation
		#print(lookDirection)
		#var axis_angle = MathCameras.normilized_direction_to_decomposed_axis_angle(lookDirection)
		#mainCamera.currentVirtualCamera.global_rotation = axis_angle
		#mainCamera.global_rotation = mainCamera.currentVirtualCamera.global_rotation
		#print(mainCamera.global_rotation, " ", axis_angle)				
