class_name CameraPositionState

var mainCamera : MainCamera

func _init(_mainCamera: MainCamera):
	mainCamera = _mainCamera

func update(delta : float):
	mainCamera.cameraSimulator.build_position()
	
	mainCamera.global_position = mainCamera.cameraSimulator.get_position(delta)
