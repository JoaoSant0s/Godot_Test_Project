class_name  CameraTransitionSimulator

var _previousCamera : VirtualCamera
var _nextCamera : VirtualCamera
var _transitionConfig : TransitionConfig

func _init(previousCamera: VirtualCamera, nextCamera : VirtualCamera, transitionConfig : TransitionConfig):
	_previousCamera = previousCamera
	_nextCamera = nextCamera
	_transitionConfig = transitionConfig

func getPosition(delta : float) -> Vector3:
	#printerr("Must override this method")
	return Vector3.ZERO
	
