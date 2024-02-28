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

func preUpdate(delta : float):
	pass

func getPosition(delta : float) -> Vector3:
	UtilsCamera.log("Must override this method")
	return Vector3.ZERO
	
func getRotation(delta : float) -> Vector3:
	UtilsCamera.log("Must override this method")
	return Vector3.ZERO

# End Override Region

func _getDefaultDuration() -> float:
	return _transitionConfig.duration

func buildPosition():
	if _nextCamera.tracking.target:
		_nextCamera.global_position = _nextCamera.tracking.target.global_position

func buildRotation():
	if _nextCamera.tracking.target and _nextCamera.tracking.IsRotationControlSameAsFollowTarget():
		_nextCamera.global_rotation = _nextCamera.tracking.target.global_rotation

func hasNextCamera() -> bool:
	return _nextCamera != null

func calculateTimeElapsed(delta : float):
	if delta < 0: return
	timedElapsed += delta
