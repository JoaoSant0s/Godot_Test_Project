class_name MainCamera extends Camera3D

static var Instance : MainCamera = null

var _currentVirtualCamera : VirtualCamera

func _ready():	
	assert(Instance == null, "Must exist a MainCamera in the scene")
	_reset()

	Instance = self
	VirtualCameraService.mainCameraStarted()
	
func _process(delta):
	_update()
	pass
	
func _physics_process(delta):	
	_update()
	pass	
	
func _update():
	if _currentVirtualCamera == null: return
	
	_trackingTarget()
	_lookAt()

func _exit_tree():
	pass

# End Region

func isCurrentCamera(virtualCamera : VirtualCamera):
	return _currentVirtualCamera == virtualCamera

func _trackingTarget():
	if _currentVirtualCamera.trackingTarget:
		global_position = _currentVirtualCamera.trackingTarget.global_position
	else:
		global_position = _currentVirtualCamera.global_position

func _lookAt():
	if _currentVirtualCamera.lookAt:
		look_at(_currentVirtualCamera.lookAt.global_position)
	else:
		rotation = _currentVirtualCamera.rotation

func _reset():
	_currentVirtualCamera = null;
	refreshProcessMethod(UtilsCamera.UpdateMethods.DISABLED);
	pass

func trySetVirtualCamera(virtualCamera : VirtualCamera):
	if virtualCamera == null:
		current = false
		_reset()
	else:
		var oldCamera : VirtualCamera = null
		print(_currentVirtualCamera, " ", virtualCamera, " ", _currentVirtualCamera == virtualCamera)
		if _currentVirtualCamera != null:
				oldCamera = _currentVirtualCamera
				if virtualCamera.priority < _currentVirtualCamera.priority: return;
				if _currentVirtualCamera == virtualCamera: return
		
		_currentVirtualCamera = virtualCamera;
		current = true
		refreshProcessMethod(_currentVirtualCamera.processMethod)
		if oldCamera != null: oldCamera.enabled = false
	pass

func refreshProcessMethod(updateMethod : UtilsCamera.UpdateMethods):
	set_process(updateMethod == UtilsCamera.UpdateMethods.DEFAULT_PROCESS)
	set_physics_process(updateMethod == UtilsCamera.UpdateMethods.PHYSICS_PROCESS)
	
	_update()
