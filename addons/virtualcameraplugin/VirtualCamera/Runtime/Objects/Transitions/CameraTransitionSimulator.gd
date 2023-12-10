class_name  CameraTransitionSimulator

var _previousCamera : VirtualCamera
var _nextCamera : VirtualCamera
var _transitionConfig : TransitionConfig

func _init(previousCamera: VirtualCamera, nextCamera : VirtualCamera, transitionConfig : TransitionConfig):
	_previousCamera = previousCamera
	_nextCamera = nextCamera
	_transitionConfig = transitionConfig

func _getDefaultDuration() -> float:
	return _transitionConfig.defaultTransitionMethod.duration
	
func getPosition(delta : float) -> Vector3:
	print("Must override this method")
	return Vector3.ZERO
	
func getRotation(delta : float) -> Vector3:
	print("Must override this method")
	return Vector3.ZERO

func buildPosition():
	if _nextCamera.tracking.target:
		_nextCamera.global_position = _nextCamera.tracking.target.global_position

func buildRotation():
	if _nextCamera.tracking.target and _nextCamera.tracking.IsRotationControlSameAsFollowTarget():
		_nextCamera.global_rotation = _nextCamera.tracking.target.global_rotation

func hasNextCamera() -> bool:
	return _nextCamera != null
