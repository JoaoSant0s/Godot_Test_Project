@tool
class_name MainCamera extends Camera3D

@export var DefaultTransition : TypeCameras.TransitionMethods = TypeCameras.TransitionMethods.CUT

static var Instance : MainCamera = null

var _currentVirtualCamera : VirtualCamera

func _ready():
	assert(Instance == null, "Must exist a MainCamera in the scene")
	_reset()

	Instance = self
	VirtualCameraService.mainCameraStarted()
	
func _process(delta):
	_tryUpdate()
	
func _physics_process(delta):	
	_tryUpdate()
	
func _tryUpdate():
	if _currentVirtualCamera == null: return
	
	_tryTracking()
	_tryLookAt()

# End Region

func _tryTracking():
	if _currentVirtualCamera.tracking == null: return;	
	if _currentVirtualCamera.tracking.IsPositionControlNone(): return
	
	_tracking()

func _tracking():
	if _currentVirtualCamera.tracking.target:
		_currentVirtualCamera.global_position = _currentVirtualCamera.tracking.target.global_position
	
	global_position = _currentVirtualCamera.global_position
		
func _tryLookAt():
	if _currentVirtualCamera.tracking == null: return;
	if _currentVirtualCamera.tracking.IsRotationControlNone(): return
	
	_lookAt()

func _lookAt():
	if _currentVirtualCamera.tracking.target and _currentVirtualCamera.tracking.IsRotationControlSameAsFollowTarget():
		_currentVirtualCamera.rotation = _currentVirtualCamera.tracking.target.global_rotation
		rotation = _currentVirtualCamera.rotation
		return

	if _currentVirtualCamera.tracking.lookAt:
		look_at(_currentVirtualCamera.tracking.lookAt.global_position)
	else:
		rotation = _currentVirtualCamera.rotation
		
func isCurrentCamera(camera : VirtualCamera):
	return _currentVirtualCamera == camera

func _reset():
	_currentVirtualCamera = null;
	refreshProcessMethod(TypeCameras.ProcessMethods.DISABLED);

func trySetVirtualCamera(camera : VirtualCamera):
	if camera == null:
		current = false
		_reset()
	else:
		_changeCurrentCamera(camera)

func _changeCurrentCamera(camera : VirtualCamera):
	var oldCamera : VirtualCamera = _currentVirtualCamera

	if not canChangeCurrentCamera(camera): return
	
	_resetPreviousVirtualCamera(oldCamera)

	_currentVirtualCamera = camera;
	current = true

	UtilsCamera.log("Changing: %s -> %s" % [oldCamera, _currentVirtualCamera])	
	_refreshCurrentVirtualCamera()
	
	# -- TODO: Will be removed
	if oldCamera != null: oldCamera.enabled = false

func _resetPreviousVirtualCamera(oldCamera : VirtualCamera):
	if oldCamera == null: return
	
	oldCamera.rotation = rotation
	
func canChangeCurrentCamera(camera) -> bool:
	if _currentVirtualCamera == null: return true
	
	if camera.priority < _currentVirtualCamera.priority: return false
	if _currentVirtualCamera == camera: return false
	
	return true

func _refreshCurrentVirtualCamera():
	refreshFOV()
	refreshProcessMethod(_currentVirtualCamera.processMethod)
	
	if _currentVirtualCamera.tracking and _currentVirtualCamera.tracking.IsPositionControlNone():
		global_position = _currentVirtualCamera.global_position
	
	if _currentVirtualCamera.tracking and _currentVirtualCamera.tracking.IsRotationControlNone():
		rotation = _currentVirtualCamera.rotation

func refreshFOV():
	if _currentVirtualCamera.lens == null: return
	fov = _currentVirtualCamera.lens.fov
	
func refreshProcessMethod(updateMethod : TypeCameras.ProcessMethods):
	set_process(updateMethod == TypeCameras.ProcessMethods.DEFAULT_PROCESS)
	set_physics_process(updateMethod == TypeCameras.ProcessMethods.PHYSICS_PROCESS)
	
	_tryUpdate()
