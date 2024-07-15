@tool
class_name MainCamera extends Camera3D

@export var transition_config : TransitionConfig

var current_virtual_camera : VirtualCamera
var camera_simulator : CameraTransitionSimulator

var position_state : CameraPositionState
var rotation_state : CameraRotationState
var lens_state : CameraLensState

func _ready():
	assert(not VirtualCameraService.is_main_camera_available(), "Must exist a MainCamera in the scene")
	_reset()	
	
	position_state = CameraPositionState.new(self)
	rotation_state = CameraRotationState.new(self)
	lens_state = CameraLensState.new(self)
	
	VirtualCameraService.main_camera_started(self)

func _process(delta : float):
	_try_update(delta)
	
func _physics_process(delta : float):
	_try_update(delta)
	
func _try_update(delta : float = -1):
	if not _has_current_camera(): return		
	if camera_simulator == null: return
	
	camera_simulator.pre_update(delta)
	_try_refresh_lens(delta)
	_try_tracking(delta)
	_try_look_at(delta)
	camera_simulator.calculate_time_elapsed(delta)

func _try_refresh_lens(delta : float):
	if current_virtual_camera.lens == null: return
	if not camera_simulator.has_next_camera(): return
	
	lens_state.update(delta)

func _try_tracking(delta : float):
	if current_virtual_camera.tracking == null: return;	
	if current_virtual_camera.tracking.is_position_control_none(): return
	if not camera_simulator.has_next_camera(): return
		
	position_state.update(delta)

func _try_look_at(delta : float):
	if current_virtual_camera.tracking == null: return;
	if current_virtual_camera.tracking.is_rotation_control_none(): return	
	if not camera_simulator.has_next_camera(): return
	
	rotation_state.update(delta)

func is_current_camera(camera : VirtualCamera):
	return current_virtual_camera == camera

func _has_current_camera() -> bool:
	return current_virtual_camera != null

func _reset():
	current_virtual_camera = null;
	VirtualCameraService.on_virtual_camera_modified.emit(current_virtual_camera)
	_refresh_process_method(TypeCameras.ProcessMethods.DISABLED);

func try_set_virtual_camera(camera : VirtualCamera):
	if camera == null:
		current = false
		_reset()
	elif can_change_current_camera(camera):
		change_current_camera(camera)

func refresh_cull_mask():
	if current_virtual_camera == null: return
	if current_virtual_camera.lens == null: return
	
	cull_mask = current_virtual_camera.lens.cull_mask
		
	current_virtual_camera.lens.cull_mask
func change_current_camera(camera : VirtualCamera):
	var oldCamera : VirtualCamera = current_virtual_camera
	
	_reset_previous_virtual_camera(oldCamera)

	current_virtual_camera = camera;
	current = true

	UtilsCamera.log("Changing: %s -> %s" % [oldCamera, current_virtual_camera])
	
	camera_simulator = VirtualCameraService.build_camera_simulation(oldCamera, current_virtual_camera, transition_config)
	refresh_cull_mask()
	_refresh_process_method(current_virtual_camera.processMethod)
	VirtualCameraService.on_virtual_camera_modified.emit(current_virtual_camera)

func _reset_previous_virtual_camera(oldCamera : VirtualCamera):
	if oldCamera == null: return
	
	oldCamera.global_rotation = global_rotation
	
func can_change_current_camera(camera : VirtualCamera) -> bool:
	if not _has_current_camera(): return true
	
	if camera.priority < current_virtual_camera.priority: return false
	if current_virtual_camera == camera: return false
	
	return true

func _refresh_process_method(updateMethod : TypeCameras.ProcessMethods):
	set_process(updateMethod == TypeCameras.ProcessMethods.DEFAULT_PROCESS)
	set_physics_process(updateMethod == TypeCameras.ProcessMethods.PHYSICS_PROCESS)
	
	_try_update()
