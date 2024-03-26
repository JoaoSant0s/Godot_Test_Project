@tool
extends Node

signal onEnabledModified(camera : VirtualCamera)
signal onPriorityModified(camera : VirtualCamera)

var _virtualCameras : Array[VirtualCamera]
var _mainCamera : MainCamera = null
var _simulationFactory : Dictionary = {}

func _init():
	#TODO: We need to refresh the project to apply new changes on this part of the code
	_simulationFactory[TypeCameras.TransitionMethods.CUT] = func(pCamera: VirtualCamera, nCamera : VirtualCamera, methodConfig : TransitionMethodConfig) -> CameraTransitionSimulator:
		return CutTransitionSimulator.new(pCamera, nCamera, methodConfig)
		
	_simulationFactory[TypeCameras.TransitionMethods.LINEAR] = func(pCamera: VirtualCamera, nCamera : VirtualCamera, methodConfig : TransitionMethodConfig) -> CameraTransitionSimulator:
		return LinearTransitionSimulator.new(pCamera, nCamera, methodConfig)

func _ready():
	onEnabledModified.connect(_virtual_camera_enabled_modified)
	onPriorityModified.connect(_virtual_camera_priority_modified)

func add_virtual_camera(camera : VirtualCamera):
	_virtualCameras.append(camera)
	
	UtilsCamera.log("Add Virtual Camera: %s" % camera.name)
	
	if not is_main_camera_available(): return
	if not camera.enabled: return
	
	_virtual_camera_enabled_modified(camera)
	
func remove_virtual_camera(camera : VirtualCamera):
	_virtualCameras.erase(camera)
	
	UtilsCamera.log("Remove Virtual Camera: %s" % camera.name)
	
	if not is_main_camera_available(): return
	if not camera.enabled: return
	
	if _mainCamera.is_current_camera(camera):
		_try_refresh_main_camera();

func main_camera_started(mainCamera : MainCamera):
	UtilsCamera.log("MainCamera added: %s" % mainCamera.name)
	_mainCamera = mainCamera
	_try_refresh_main_camera();

func is_main_camera_available():
	return _mainCamera != null

func get_main_camera():
	return _mainCamera

func find_enabled_virtual_cameras() -> Array[VirtualCamera]:
	return _virtualCameras.filter(func(camera : VirtualCamera): return camera.enabled)

func find_virtual_cameras() -> Array[VirtualCamera]:
	return _virtualCameras.duplicate()
	
func is_current_camera(camera : VirtualCamera):
	if not is_main_camera_available(): return false
	return _mainCamera.is_current_camera(camera)

func force_active(camera : VirtualCamera):
	if not is_main_camera_available() or camera == null: return
	camera.enabled = true

	if _mainCamera.is_current_camera(camera): return
	_mainCamera.change_current_camera(camera)

func _virtual_camera_enabled_modified(camera : VirtualCamera):
	if not is_main_camera_available(): return

	if camera.enabled:
		_mainCamera.try_set_virtual_camera(camera);
	elif _mainCamera.is_current_camera(camera):
		_try_refresh_main_camera()

func _virtual_camera_priority_modified(camera : VirtualCamera):
	if not is_main_camera_available(): return
	if not camera.enabled: return;
	
	if _mainCamera.is_current_camera(camera):
		_try_refresh_main_camera()
	else:
		_mainCamera.try_set_virtual_camera(camera);

func _try_refresh_main_camera():
	if not is_main_camera_available(): return
	
	var runningCameras : Array[VirtualCamera] = _virtualCameras.filter(func(camera : VirtualCamera): return camera.enabled)
	
	if runningCameras.size() == 0:
		_mainCamera.try_set_virtual_camera(null);
		return
	UtilsCamera.log("Sorting for enabled virtual cameras: %s" % runningCameras.size())
	
	runningCameras.sort_custom(func(cameraA : VirtualCamera, cameraB : VirtualCamera): return cameraA.priority > cameraB.priority);
	_mainCamera.try_set_virtual_camera(runningCameras[0]);

func is_tag_unique(camera : VirtualCamera):
	var selectedCameras : Array[VirtualCamera] = _virtualCameras.filter(func(virtual : VirtualCamera): return virtual.tag == camera.tag)	
	
	var isUnique = selectedCameras.size() <= 1
	
	UtilsCamera.extract_resource_name(camera.tag)
	
	if not isUnique: UtilsCamera.log("Already has a Virtual Camera with tag: %s" % UtilsCamera.extract_resource_name(camera.tag))
		
	return isUnique

func build_camera_simulation(pCamera: VirtualCamera, nCamera : VirtualCamera, config : TransitionConfig) -> CameraTransitionSimulator:
	var transitionMethod = config.get_matched_transition_method(pCamera, nCamera)
	
	assert(_simulationFactory.has(transitionMethod.type), "Must create a trasition class of the type %s" % transitionMethod.type)
	return _simulationFactory[transitionMethod.type].call(pCamera, nCamera, transitionMethod)
