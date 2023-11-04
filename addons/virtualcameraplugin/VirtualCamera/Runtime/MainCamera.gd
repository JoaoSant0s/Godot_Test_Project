@tool
class_name MainCamera extends Camera3D

@export var transitionConfig : TransitionConfig

var _currentVirtualCamera : VirtualCamera
var _cameraSimulator : CameraTransitionSimulator

func _ready():
	assert(not VirtualCameraService.isMainCameraAvailable(), "Must exist a MainCamera in the scene")
	_reset()
	
	VirtualCameraService.mainCameraStarted(self)
	
func _process(delta : float):
	_tryUpdate(delta)
	
func _physics_process(delta : float):
	_tryUpdate(delta)
	
func _tryUpdate(delta : float = -1):
	if not _hasCurrentCamera(): return		
	_refreshLens()
	if _cameraSimulator == null: return
	
	_tryTracking(delta)
	_tryLookAt(delta)

# End Region

func _tryTracking(delta : float):
	if _currentVirtualCamera.tracking == null: return;	
	if _currentVirtualCamera.tracking.IsPositionControlNone(): return	
	
	if not _cameraSimulator.hasNextCamera(): return
	_cameraSimulator.buildPosition()
	
	global_position = _cameraSimulator.getPosition(delta)
		
func _tryLookAt(delta : float):
	if _currentVirtualCamera.tracking == null: return;
	if _currentVirtualCamera.tracking.IsRotationControlNone(): return
	
	_lookAt(delta)

func _lookAt(delta):
	if _currentVirtualCamera.tracking.target and _currentVirtualCamera.tracking.IsRotationControlSameAsFollowTarget():
		_currentVirtualCamera.rotation = _currentVirtualCamera.tracking.target.global_rotation
		rotation = _currentVirtualCamera.rotation
		return
	
	if _currentVirtualCamera.tracking.lookAt:
		look_at(_currentVirtualCamera.tracking.lookAt.global_position)
		_currentVirtualCamera.rotation = rotation
	else:
		rotation = _currentVirtualCamera.rotation
		
func isCurrentCamera(camera : VirtualCamera):
	return _currentVirtualCamera == camera

func _hasCurrentCamera() -> bool:
	return _currentVirtualCamera != null

func _reset():
	_currentVirtualCamera = null;
	refreshProcessMethod(TypeCameras.ProcessMethods.DISABLED);

func trySetVirtualCamera(camera : VirtualCamera):
	if camera == null:
		current = false
		_reset()
	elif canChangeCurrentCamera(camera):
		changeCurrentCamera(camera)
	
func changeCurrentCamera(camera : VirtualCamera):
	var oldCamera : VirtualCamera = _currentVirtualCamera
	
	_resetPreviousVirtualCamera(oldCamera)

	_currentVirtualCamera = camera;
	current = true

	UtilsCamera.log("Changing: %s -> %s" % [oldCamera, _currentVirtualCamera])
	
	_cameraSimulator = VirtualCameraService.buildCameraSimulation(oldCamera, _currentVirtualCamera, transitionConfig)
	refreshProcessMethod(_currentVirtualCamera.processMethod)

func _resetPreviousVirtualCamera(oldCamera : VirtualCamera):
	if oldCamera == null: return
	
	oldCamera.rotation = rotation
	
func canChangeCurrentCamera(camera : VirtualCamera) -> bool:
	if not _hasCurrentCamera(): return true
	
	if camera.priority < _currentVirtualCamera.priority: return false
	if _currentVirtualCamera == camera: return false
	
	return true

func _refreshLens():
	if _currentVirtualCamera.lens == null: return
	fov = _currentVirtualCamera.lens.fov
	
func refreshProcessMethod(updateMethod : TypeCameras.ProcessMethods):
	set_process(updateMethod == TypeCameras.ProcessMethods.DEFAULT_PROCESS)
	set_physics_process(updateMethod == TypeCameras.ProcessMethods.PHYSICS_PROCESS)
	
	_tryUpdate()
