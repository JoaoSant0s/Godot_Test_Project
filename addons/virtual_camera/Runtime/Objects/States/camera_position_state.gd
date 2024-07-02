class_name CameraPositionState

var main_camera : MainCamera

func _init(_main_camera: MainCamera):
	main_camera = _main_camera

func update(delta : float):
	main_camera.camera_simulator.build_position(delta)
	
	main_camera.global_position = main_camera.camera_simulator.get_position(delta)
