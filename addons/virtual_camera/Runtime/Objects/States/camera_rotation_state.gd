class_name CameraRotationState

var main_camera : MainCamera

func _init(_main_camera: MainCamera):
	main_camera = _main_camera

func update(delta : float):
	var tracking = main_camera.current_virtual_camera.tracking
	var global_rotation : Vector3
	if not tracking.look_at:
		main_camera.camera_simulator.build_rotation()
		global_rotation = main_camera.camera_simulator.get_rotation(delta)
	else:
		var targetPosition : Vector3 = tracking.look_at.global_position + tracking.get_follow_offset()
		var cameraPosition : Vector3 = main_camera.global_position
		var lookDirection = (targetPosition - cameraPosition).normalized()
		
		global_rotation = MathCameras.normilized_direction_to_decomposed_axis_angle(lookDirection)
		main_camera.current_virtual_camera.global_rotation = global_rotation		

	main_camera.global_rotation = global_rotation
