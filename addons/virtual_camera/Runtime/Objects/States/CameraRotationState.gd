class_name CameraRotationState

var mainCamera : MainCamera

func _init(_mainCamera: MainCamera):
	mainCamera = _mainCamera

func update(delta : float):
	if not mainCamera.currentVirtualCamera.tracking.lookAt:
		mainCamera.cameraSimulator.build_rotation()
		mainCamera.global_rotation = mainCamera.cameraSimulator.get_rotation(delta)
	else:
		mainCamera.look_at(mainCamera.currentVirtualCamera.tracking.lookAt.global_position)
		mainCamera.currentVirtualCamera.global_rotation = mainCamera.global_rotation
