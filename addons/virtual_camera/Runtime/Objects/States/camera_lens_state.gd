class_name CameraLensState

var mainCamera : MainCamera

func _init(_mainCamera: MainCamera):
	mainCamera = _mainCamera

func update(delta : float):
	mainCamera.fov = mainCamera.cameraSimulator.get_fov(delta)
