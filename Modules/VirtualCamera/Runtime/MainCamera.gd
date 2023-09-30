class_name MainCamera extends Camera3D

static var Instance : MainCamera = null

var currentVirtualCamera : VirtualCamera

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
	if currentVirtualCamera == null: return
	
	_follow()
	_lookAt()

func _exit_tree():
	pass

# End Region

func _follow():
	if currentVirtualCamera.follow:
		global_position = currentVirtualCamera.follow.global_position
	else:
		global_position = currentVirtualCamera.global_position

func _lookAt():
	if currentVirtualCamera.lookAt:
		look_at(currentVirtualCamera.lookAt.global_position)
	else:
		global_rotation = currentVirtualCamera.global_rotation

func _reset():
	currentVirtualCamera = null;
	refreshProcessMethod(UtilsCamera.UpdateMethods.DISABLED);
	pass

func setVirtualCamera(virtualCamera : VirtualCamera):
	currentVirtualCamera = virtualCamera;
	if currentVirtualCamera == null:
		_reset()
	else:
		refreshProcessMethod(currentVirtualCamera.processMethod)
	pass

func refreshProcessMethod(updateMethod : UtilsCamera.UpdateMethods):
	set_process(updateMethod == UtilsCamera.UpdateMethods.PROCESS)
	set_physics_process(updateMethod == UtilsCamera.UpdateMethods.PHYSICS_PROCESS)
	pass

func refreshStatus(virtualCamera : VirtualCamera):
	var isSameCamera = virtualCamera == currentVirtualCamera;
	
	print(virtualCamera.isStatusRunning(), not isSameCamera)
	print(virtualCamera.isStatusDisabled(), isSameCamera)
	
	if virtualCamera.isStatusRunning() and not isSameCamera:
		setVirtualCamera(virtualCamera)
	elif virtualCamera.isStatusDisabled() and isSameCamera:
		_reset();
	pass


