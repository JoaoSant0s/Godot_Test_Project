@tool
extends Node

signal onEnabledModified(camera : VirtualCamera)
signal onPriorityModified(camera : VirtualCamera)

var _virtualCameras : Array[VirtualCamera]
var _mainCamera : MainCamera = null
var _simulationFactory : Dictionary = {}

func _init():
	#TODO: We need to refresh the project to apply new changes on this part of the code
	_simulationFactory[TypeCameras.TransitionMethods.CUT] = func(pCamera: VirtualCamera, nCamera : VirtualCamera, config : TransitionConfig) -> CameraTransitionSimulator:
		return CutTransitionSimulator.new(pCamera, nCamera, config)
		
	_simulationFactory[TypeCameras.TransitionMethods.LINEAR] = func(pCamera: VirtualCamera, nCamera : VirtualCamera, config : TransitionConfig) -> CameraTransitionSimulator:
		return LinearTransitionSimulator.new(pCamera, nCamera, config)

func _ready():
	onEnabledModified.connect(_virtualCameraEnabledModified)
	onPriorityModified.connect(_virtualCameraPriorityModified)

func addVirtualCamera(camera : VirtualCamera):
	_virtualCameras.append(camera)
	
	UtilsCamera.log("Add Virtual Camera: %s" % camera.name)
	
	if not isMainCameraAvailable(): return
	if not camera.enabled: return
	
	_virtualCameraEnabledModified(camera)
	
func removeVirtualCamera(camera : VirtualCamera):
	_virtualCameras.erase(camera)
	
	UtilsCamera.log("Remove Virtual Camera: %s" % camera.name)
	
	if not isMainCameraAvailable(): return
	if not camera.enabled: return
	
	if _mainCamera.isCurrentCamera(camera):
		_tryRefreshMainCamera();

func mainCameraStarted(mainCamera : MainCamera):
	UtilsCamera.log("MainCamera added: %s" % mainCamera.name)
	_mainCamera = mainCamera
	_tryRefreshMainCamera();

func isMainCameraAvailable():
	return _mainCamera != null

func getMainCamera():
	return _mainCamera

func findEnabledVirtualCameras() -> Array[VirtualCamera]:
	return _virtualCameras.filter(func(camera : VirtualCamera): return camera.enabled)

func findVirtualCameras() -> Array[VirtualCamera]:
	return _virtualCameras.duplicate()
	
func isCurrentCamera(camera : VirtualCamera):
	if not isMainCameraAvailable(): return false
	return _mainCamera.isCurrentCamera(camera)

func forceActive(camera : VirtualCamera):
	if not isMainCameraAvailable() or camera == null: return
	camera.enabled = true

	if _mainCamera.isCurrentCamera(camera): return
	_mainCamera.changeCurrentCamera(camera)

func _virtualCameraEnabledModified(camera : VirtualCamera):
	if not isMainCameraAvailable(): return

	if camera.enabled:
		_mainCamera.trySetVirtualCamera(camera);
	elif _mainCamera.isCurrentCamera(camera):
		_tryRefreshMainCamera()

func _virtualCameraPriorityModified(camera : VirtualCamera):
	if not isMainCameraAvailable(): return
	if not camera.enabled: return;
	
	if _mainCamera.isCurrentCamera(camera):
		_tryRefreshMainCamera()
	else:
		_mainCamera.trySetVirtualCamera(camera);

func _tryRefreshMainCamera():
	if not isMainCameraAvailable(): return
	
	var runningCameras : Array[VirtualCamera] = _virtualCameras.filter(func(camera : VirtualCamera): return camera.enabled)
	
	if runningCameras.size() == 0:
		_mainCamera.trySetVirtualCamera(null);
		return
	UtilsCamera.log("Sorting for enabled virtual cameras: %s" % runningCameras.size())
	
	runningCameras.sort_custom(func(cameraA : VirtualCamera, cameraB : VirtualCamera): return cameraA.priority > cameraB.priority);
	_mainCamera.trySetVirtualCamera(runningCameras[0]);

func isTagUnique(camera : VirtualCamera):
	var selectedCameras : Array[VirtualCamera] = _virtualCameras.filter(func(virtual : VirtualCamera): return virtual.tag == camera.tag)	
	
	var isUnique = selectedCameras.size() <= 1
	
	UtilsCamera.extractResourceName(camera.tag)
	
	if not isUnique: UtilsCamera.log("Already has a Virtual Camera with tag: %s" % UtilsCamera.extractResourceName(camera.tag))
		
	return isUnique

func buildCameraSimulation(pCamera: VirtualCamera, nCamera : VirtualCamera, config : TransitionConfig) -> CameraTransitionSimulator:
	var type = config.defaultTransitionMethod.type
	
	assert(_simulationFactory.has(type), "Must create a trasition class of the type %s" % type)
	return _simulationFactory[type].call(pCamera, nCamera, config)
