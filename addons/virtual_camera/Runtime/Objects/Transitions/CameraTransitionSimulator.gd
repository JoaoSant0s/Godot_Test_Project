class_name  CameraTransitionSimulator

var _previousCamera : VirtualCamera
var _nextCamera : VirtualCamera
var _transitionConfig : TransitionMethodConfig
var timedElapsed : float

func _init(previousCamera: VirtualCamera, nextCamera : VirtualCamera, transitionConfig : TransitionMethodConfig):
	_previousCamera = previousCamera
	_nextCamera = nextCamera
	_transitionConfig = transitionConfig
	timedElapsed = 0

# Start Override Region

func pre_update(delta : float):
	pass

func get_position(delta : float) -> Vector3:
	UtilsCamera.log("Must override this method")
	return Vector3.ZERO
	
func get_rotation(delta : float) -> Vector3:
	UtilsCamera.log("Must override this method")
	return Vector3.ZERO

# End Override Region

func _get_default_duration() -> float:
	return _transitionConfig.duration

func build_position():
	if _nextCamera.tracking.target:
		_nextCamera.global_position = _nextCamera.tracking.get_position()

func build_rotation():
	if _nextCamera.tracking.target and _nextCamera.tracking.is_rotation_control_same_as_follow_target():
		_nextCamera.global_rotation = _nextCamera.tracking.target.global_rotation

func has_next_camera() -> bool:
	return _nextCamera != null

func calculate_time_elapsed(delta : float):
	if delta < 0: return
	timedElapsed += delta
