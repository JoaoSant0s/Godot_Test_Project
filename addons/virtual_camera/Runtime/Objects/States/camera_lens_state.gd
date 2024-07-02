class_name CameraLensState

var main_camera : MainCamera

func _init(_main_camera: MainCamera):
	main_camera = _main_camera

func update(delta : float):
	main_camera.fov = main_camera.camera_simulator.get_fov(delta)
