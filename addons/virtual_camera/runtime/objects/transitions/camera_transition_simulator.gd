class_name  CameraTransitionSimulator

var _previous_camera : VirtualCamera
var _next_camera : VirtualCamera
var _transition_config : TransitionMethodConfig

var timed_elapsed : float

func _init(previous_Camera: VirtualCamera, next_camera : VirtualCamera, transition_config : TransitionMethodConfig):
	_previous_camera = previous_Camera
	_next_camera = next_camera
	_transition_config = transition_config
	timed_elapsed = 0

# Start Override Region
func pre_update(delta : float):
	pass

func get_fov(delta : float) -> float:
	UtilsCamera.log("Must override this method")
	return 0

func get_position(delta : float) -> Vector3:
	UtilsCamera.log("Must override this method")
	return Vector3.ZERO
	
func get_rotation(delta : float) -> Vector3:
	UtilsCamera.log("Must override this method")
	return Vector3.ZERO

# End Override Region
func _get_default_duration() -> float:
	return _transition_config.duration

func build_position(delta : float):
	var next_camera_position : Vector3 = _next_camera.global_position
	
	if _next_camera.tracking.is_component_ready():
		next_camera_position = _next_camera.tracking.get_position()
	
	next_camera_position += _next_camera.tracking.get_local_position_control()
	_next_camera.global_position = next_camera_position

func build_rotation():
	if _next_camera.tracking.target and _next_camera.tracking.is_rotation_control_same_as_follow_target():
		_next_camera.global_rotation = _next_camera.tracking.target.global_rotation
	elif _next_camera.tracking.is_tilt_rotate_on_path():
		_next_camera.global_rotation = _next_camera.tracking.path_follow.global_rotation
		_next_camera.global_rotation =+ _next_camera.tracking.tilt_rotate_angle_on_path

func has_next_camera() -> bool:
	return _next_camera != null

func calculate_time_elapsed(delta : float):
	if delta < 0: return
	timed_elapsed += delta
