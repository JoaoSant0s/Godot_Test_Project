@tool
extends Node

signal on_enabled_modified(camera : VirtualCamera)
signal on_priority_modified(camera : VirtualCamera)
signal on_virtual_camera_modified(camera : VirtualCamera)

var _virtual_cameras : Array[VirtualCamera]
var _main_camera : MainCamera = null
var _simulation_factory : Dictionary = {}

func _init():
	#TODO: We need to refresh the project to apply new changes on this part of the code
	_simulation_factory[TypeCameras.TransitionMethods.CUT] = func(pCamera: VirtualCamera, nCamera : VirtualCamera, methodConfig : TransitionMethodConfig) -> CameraTransitionSimulator:
		return CutTransitionSimulator.new(pCamera, nCamera, methodConfig)
		
	_simulation_factory[TypeCameras.TransitionMethods.LINEAR] = func(pCamera: VirtualCamera, nCamera : VirtualCamera, methodConfig : TransitionMethodConfig) -> CameraTransitionSimulator:
		return LinearTransitionSimulator.new(pCamera, nCamera, methodConfig)

func _ready():
	on_enabled_modified.connect(_virtual_camera_enabled_modified)
	on_priority_modified.connect(_virtual_camera_priority_modified)

func add_virtual_camera(camera : VirtualCamera):
	_virtual_cameras.append(camera)
	
	UtilsCamera.log("Add Virtual Camera: %s" % camera.name)
	
	if not is_main_camera_available(): return
	if not camera.enabled: return
	
	_virtual_camera_enabled_modified(camera)
	
func remove_virtual_camera(camera : VirtualCamera):
	_virtual_cameras.erase(camera)
	
	UtilsCamera.log("Remove Virtual Camera: %s" % camera.name)
	
	if not is_main_camera_available(): return
	if not camera.enabled: return
	
	if _main_camera.is_current_camera(camera):
		_try_refresh_main_camera();

func main_camera_started(mainCamera : MainCamera):
	UtilsCamera.log("MainCamera added: %s" % mainCamera.name)
	_main_camera = mainCamera
	_try_refresh_main_camera();

func is_main_camera_available():
	return _main_camera != null

func get_main_camera() -> MainCamera:
	return _main_camera

func find_enabled_virtual_cameras() -> Array[VirtualCamera]:
	return _virtual_cameras.filter(func(camera : VirtualCamera): return camera.enabled)

func find_virtual_cameras() -> Array[VirtualCamera]:
	return _virtual_cameras.duplicate()

func refresh_cull_mask():
	if not is_main_camera_available(): return
	_main_camera.refresh_cull_mask()

func is_current_camera(camera : VirtualCamera):
	if not is_main_camera_available(): return false
	return _main_camera.is_current_camera(camera)

func force_active(camera : VirtualCamera):
	if not is_main_camera_available() or camera == null: return
	camera.enabled = true

	if _main_camera.is_current_camera(camera): return
	_main_camera.change_current_camera(camera)

func _virtual_camera_enabled_modified(camera : VirtualCamera):
	if not is_main_camera_available(): return

	if camera.enabled:
		_main_camera.try_set_virtual_camera(camera);
	elif _main_camera.is_current_camera(camera):
		_try_refresh_main_camera()

func _virtual_camera_priority_modified(camera : VirtualCamera):
	if not is_main_camera_available(): return
	if not camera.enabled: return;
	
	if _main_camera.is_current_camera(camera):
		_try_refresh_main_camera()
	else:
		_main_camera.try_set_virtual_camera(camera);

func _try_refresh_main_camera():
	if not is_main_camera_available(): return
	
	var runningCameras : Array[VirtualCamera] = _virtual_cameras.filter(func(camera : VirtualCamera): return camera.enabled)
	
	if runningCameras.size() == 0:
		_main_camera.try_set_virtual_camera(null);
		return
	UtilsCamera.log("Sorting for enabled virtual cameras: %s" % runningCameras.size())
	
	runningCameras.sort_custom(func(cameraA : VirtualCamera, cameraB : VirtualCamera): return cameraA.priority > cameraB.priority);
	_main_camera.try_set_virtual_camera(runningCameras[0]);

func is_tag_unique(camera : VirtualCamera):
	var selectedCameras : Array[VirtualCamera] = _virtual_cameras.filter(func(virtual : VirtualCamera): return virtual.tag == camera.tag)	
	
	var isUnique = selectedCameras.size() <= 1
	
	UtilsCamera.extract_resource_name(camera.tag)
	
	if not isUnique: UtilsCamera.log("Already has a Virtual Camera with tag: %s" % UtilsCamera.extract_resource_name(camera.tag))
		
	return isUnique

func build_camera_simulation(pCamera: VirtualCamera, nCamera : VirtualCamera, config : TransitionConfig) -> CameraTransitionSimulator:
	var transition_method = config.get_matched_transition_method(pCamera, nCamera)
	
	assert(_simulation_factory.has(transition_method.type), "Must create a trasition class of the type %s" % transition_method.type)
	return _simulation_factory[transition_method.type].call(pCamera, nCamera, transition_method)
