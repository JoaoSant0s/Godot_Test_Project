class_name  CameraTransitionSimulator

var _previousCamera : VirtualCamera
var _nextCamera : VirtualCamera
var _transitionConfig : TransitionConfig

func _init(previousCamera: VirtualCamera, nextCamera : VirtualCamera, transitionConfig : TransitionConfig):
	_previousCamera = previousCamera
	_nextCamera = nextCamera
	_transitionConfig = transitionConfig

func getPosition() -> Vector3:
	var position : Vector3

	if _nextCamera.tracking.target:
		_nextCamera.global_position = _nextCamera.tracking.target.global_position
	
	position = _nextCamera.global_position
		
	return position
