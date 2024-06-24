class_name LinearTransitionSimulator extends CameraTransitionSimulator

var time_percentage : float

func build_time_percentage():
	var duration = _get_default_duration()
	time_percentage = timed_elapsed / duration
	time_percentage = min(1, time_percentage)
	
func pre_update(delta : float):
	build_time_percentage()

func get_fov(delta : float) -> float:
	var nextFov = _next_camera.lens.fov if _next_camera.lens else 75
	
	if _previous_camera == null: return nextFov	
	var previous_fov = _previous_camera.lens.fov if _previous_camera.lens else 75
	
	if delta < 0: return previous_fov
	
	if time_percentage >= 1: return nextFov
	
	return lerp(previous_fov, nextFov, time_percentage)
	
func get_position(delta : float) -> Vector3:
	var next_position = _next_camera.global_position
	
	if _previous_camera == null: return next_position
	if delta < 0: return _previous_camera.global_position

	if time_percentage >= 1: return next_position
	
	return _previous_camera.global_position.lerp(next_position, time_percentage)

func get_rotation(delta : float) -> Vector3:
	var next_rotation = _next_camera.global_rotation

	if _previous_camera == null: return next_rotation
	if delta < 0: return _previous_camera.global_rotation
	
	if time_percentage >= 1: return next_rotation

	return _previous_camera.global_rotation.lerp(next_rotation, time_percentage)
