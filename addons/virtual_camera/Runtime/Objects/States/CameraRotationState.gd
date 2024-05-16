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
		mainCamera.look_at(tracking.lookAt.global_position + tracking.get_follow_offset())
		mainCamera.currentVirtualCamera.global_rotation = mainCamera.global_rotation
