class_name  CameraTransitionSimulator

var _previousCamera : VirtualCamera
var _nextCamera : VirtualCamera
var _transitionConfig : TransitionMethodConfig
var _dampedSprintMotion : tDampedSpringMotionParams

var timedElapsed : float
#var position : Vector3
#var velocity : Vector3

func _init(previousCamera: VirtualCamera, nextCamera : VirtualCamera, transitionConfig : TransitionMethodConfig):
	_previousCamera = previousCamera
	_nextCamera = nextCamera
	_transitionConfig = transitionConfig
	timedElapsed = 0
	#velocity = Vector3.ZERO
	#
	#if previousCamera:
		#position = previousCamera.global_position
	#elif nextCamera:
		#position = nextCamera.global_position
	#else:
		#position = Vector3.ZERO	
	#_dampedSprintMotion = tDampedSpringMotionParams.new()
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
	return _transitionConfig.duration

func build_position(delta : float):
	var nextCameraPosition = _nextCamera.global_position
	
	if _nextCamera.tracking.target:
		nextCameraPosition = _nextCamera.tracking.get_position()
	
	# TODO Make here the damping transition effect
	#dampedSpringMotion.CalcDampedSpringMotionParams(_dampedSprintMotion, delta, 1,  1)
	#var result = dampedSpringMotion.UpdateDampedSpringMotionVector(velocity, position, nextCameraPosition, _dampedSprintMotion)
	#var result = dampedSpringMotion.UpdateDampedSpringMotion(velocity.y, position.y, nextCameraPosition.y, _dampedSprintMotion)
	#position.x = nextCameraPosition.x
	#position.z = nextCameraPosition.z
	#position.y = result.pPos
	#velocity.y = result.pVel
	#_nextCamera.global_position = position
	_nextCamera.global_position = nextCameraPosition

	_nextCamera.global_position += _nextCamera.tracking.get_local_position_control()

func build_rotation():
	if _nextCamera.tracking.target and _nextCamera.tracking.is_rotation_control_same_as_follow_target():
		_nextCamera.global_rotation = _nextCamera.tracking.target.global_rotation

func has_next_camera() -> bool:
	return _nextCamera != null

func calculate_time_elapsed(delta : float):
	if delta < 0: return
	timedElapsed += delta
