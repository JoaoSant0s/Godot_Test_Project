@tool
class_name MainCamera extends Camera3D

@export var transitionConfig : TransitionConfig

var currentVirtualCamera : VirtualCamera
var cameraSimulator : CameraTransitionSimulator

var positionState : CameraPositionState
var rotationState : CameraRotationState

func _ready():
	assert(not VirtualCameraService.is_main_camera_available(), "Must exist a MainCamera in the scene")
	_reset()
	positionState = CameraPositionState.new(self)
	rotationState = CameraRotationState.new(self)
	VirtualCameraService.main_camera_started(self)
	
func _process(delta : float):
	_try_update(delta)
	
func _physics_process(delta : float):
	_try_update(delta)
	
func _try_update(delta : float = -1):
	if not _has_current_camera(): return		
	_refresh_lens()
	if cameraSimulator == null: return
	
	cameraSimulator.pre_update(delta)
	_try_tracking(delta)
	_try_look_at(delta)
	cameraSimulator.calculate_time_elapsed(delta)

func _try_tracking(delta : float):
	if currentVirtualCamera.tracking == null: return;	
	if currentVirtualCamera.tracking.is_position_control_none(): return
	if not cameraSimulator.has_next_camera(): return
		
	positionState.update(delta)

func _try_look_at(delta : float):
	if currentVirtualCamera.tracking == null: return;
	if currentVirtualCamera.tracking.is_rotation_control_none(): return	
	if not cameraSimulator.has_next_camera(): return
	
	rotationState.update(delta)

func is_current_camera(camera : VirtualCamera):
	return currentVirtualCamera == camera

func _has_current_camera() -> bool:
	return currentVirtualCamera != null

func _reset():
	currentVirtualCamera = null;
	_refresh_process_method(TypeCameras.ProcessMethods.DISABLED);

func try_set_virtual_camera(camera : VirtualCamera):
	if camera == null:
		current = false
		_reset()
	elif can_change_current_camera(camera):
		change_current_camera(camera)
	
func change_current_camera(camera : VirtualCamera):
	var oldCamera : VirtualCamera = currentVirtualCamera
	
	_reset_previous_virtual_camera(oldCamera)

	currentVirtualCamera = camera;
	current = true

	UtilsCamera.log("Changing: %s -> %s" % [oldCamera, currentVirtualCamera])
	
	cameraSimulator = VirtualCameraService.build_camera_simulation(oldCamera, currentVirtualCamera, transitionConfig)
	_refresh_process_method(currentVirtualCamera.processMethod)

func _reset_previous_virtual_camera(oldCamera : VirtualCamera):
	if oldCamera == null: return
	
	oldCamera.global_rotation = global_rotation
	
func can_change_current_camera(camera : VirtualCamera) -> bool:
	if not _has_current_camera(): return true
	
	if camera.priority < currentVirtualCamera.priority: return false
	if currentVirtualCamera == camera: return false
	
	return true

func _refresh_lens():
	if currentVirtualCamera.lens == null: return
	fov = currentVirtualCamera.lens.fov
	
func _refresh_process_method(updateMethod : TypeCameras.ProcessMethods):
	set_process(updateMethod == TypeCameras.ProcessMethods.DEFAULT_PROCESS)
	set_physics_process(updateMethod == TypeCameras.ProcessMethods.PHYSICS_PROCESS)
	
	_try_update()
