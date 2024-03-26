@tool
class_name MainCamera extends Camera3D

@export var transitionConfig : TransitionConfig

var _currentVirtualCamera : VirtualCamera
var _cameraSimulator : CameraTransitionSimulator

func _ready():
	assert(not VirtualCameraService.is_main_camera_available(), "Must exist a MainCamera in the scene")
	_reset()
	
	VirtualCameraService.main_camera_started(self)
	
func _process(delta : float):
	_try_update(delta)
	
func _physics_process(delta : float):
	_try_update(delta)
	
func _try_update(delta : float = -1):
	if not _has_current_camera(): return		
	_refresh_lens()
	if _cameraSimulator == null: return
	
	_cameraSimulator.pre_update(delta)
	_try_tracking(delta)
	_try_look_at(delta)
	_cameraSimulator.calculate_time_elapsed(delta)

func _try_tracking(delta : float):
	if _currentVirtualCamera.tracking == null: return;	
	if _currentVirtualCamera.tracking.is_position_control_none(): return	
	
	if not _cameraSimulator.has_next_camera(): return
	_cameraSimulator.build_position()
	
	global_position = _cameraSimulator.get_position(delta)

func _try_look_at(delta : float):
	if _currentVirtualCamera.tracking == null: return;
	if _currentVirtualCamera.tracking.is_rotation_control_none(): return	
	if not _cameraSimulator.has_next_camera(): return
	
	if not _currentVirtualCamera.tracking.lookAt:
		_cameraSimulator.build_rotation()
		global_rotation = _cameraSimulator.get_rotation(delta)
	else:
		look_at(_currentVirtualCamera.tracking.lookAt.global_position)
		_currentVirtualCamera.global_rotation = global_rotation

func is_current_camera(camera : VirtualCamera):
	return _currentVirtualCamera == camera

func _has_current_camera() -> bool:
	return _currentVirtualCamera != null

func _reset():
	_currentVirtualCamera = null;
	_refresh_process_method(TypeCameras.ProcessMethods.DISABLED);

func try_set_virtual_camera(camera : VirtualCamera):
	if camera == null:
		current = false
		_reset()
	elif can_change_current_camera(camera):
		change_current_camera(camera)
	
func change_current_camera(camera : VirtualCamera):
	var oldCamera : VirtualCamera = _currentVirtualCamera
	
	_reset_previous_virtual_camera(oldCamera)

	_currentVirtualCamera = camera;
	current = true

	UtilsCamera.log("Changing: %s -> %s" % [oldCamera, _currentVirtualCamera])
	
	_cameraSimulator = VirtualCameraService.build_camera_simulation(oldCamera, _currentVirtualCamera, transitionConfig)
	_refresh_process_method(_currentVirtualCamera.processMethod)

func _reset_previous_virtual_camera(oldCamera : VirtualCamera):
	if oldCamera == null: return
	
	oldCamera.global_rotation = global_rotation
	
func can_change_current_camera(camera : VirtualCamera) -> bool:
	if not _has_current_camera(): return true
	
	if camera.priority < _currentVirtualCamera.priority: return false
	if _currentVirtualCamera == camera: return false
	
	return true

func _refresh_lens():
	if _currentVirtualCamera.lens == null: return
	fov = _currentVirtualCamera.lens.fov
	
func _refresh_process_method(updateMethod : TypeCameras.ProcessMethods):
	set_process(updateMethod == TypeCameras.ProcessMethods.DEFAULT_PROCESS)
	set_physics_process(updateMethod == TypeCameras.ProcessMethods.PHYSICS_PROCESS)
	
	_try_update()
