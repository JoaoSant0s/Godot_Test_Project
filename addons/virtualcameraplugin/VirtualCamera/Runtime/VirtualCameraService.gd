@tool
extends Node

signal onEnabledModified(camera : VirtualCamera)
signal onPriorityModified(camera : VirtualCamera)
signal onLensComponentModified(camera : VirtualCamera)
signal onTrackingComponentModified(camera : VirtualCamera)

var _virtualCameras : Array[VirtualCamera]

func _ready():
	onEnabledModified.connect(_virtualCameraEnabledModified)
	onPriorityModified.connect(_virtualCameraPriorityModified)
	onLensComponentModified.connect(_virtualCameraLensModified)
	onTrackingComponentModified.connect(_virtualCameraTrackingModified)

func addVirtualCamera(camera : VirtualCamera):
	_virtualCameras.append(camera)
	
	UtilsCamera.print("Add Virtual Cameraamera: %s" % camera.name)
	
	if MainCamera.Instance == null: return
	if not camera.enabled: return
	
	_virtualCameraEnabledModified(camera)
	
func removeVirtualCamera(camera : VirtualCamera):
	_virtualCameras.erase(camera)
	
	UtilsCamera.print("Remove Virtual Cameraamera: %s" % camera.name)
	
	if MainCamera.Instance == null: return
	if not camera.enabled: return
	
	if MainCamera.Instance.isCurrentCamera(camera):
		_tryRefreshMainCamera();

func mainCameraStarted():
	_tryRefreshMainCamera();

func findEnabledVirtualCameras() -> Array[VirtualCamera]:
	return _virtualCameras.filter(func(camera : VirtualCamera): return camera.enabled)

func findVirtualCameras() -> Array[VirtualCamera]:
	return _virtualCameras.duplicate()
	
func _virtualCameraEnabledModified(camera : VirtualCamera):
	if MainCamera.Instance == null: return

	if camera.enabled:
		MainCamera.Instance.trySetVirtualCamera(camera);
	elif MainCamera.Instance.isCurrentCamera(camera):
		_tryRefreshMainCamera()

func _virtualCameraPriorityModified(camera : VirtualCamera):
	if MainCamera.Instance == null: return
	if not camera.enabled: return;
	
	if MainCamera.Instance.isCurrentCamera(camera):
		_tryRefreshMainCamera()
	else:
		MainCamera.Instance.trySetVirtualCamera(camera);

func _virtualCameraLensModified(camera : VirtualCamera):
	if not _isCurrentCamera(camera): return
	
	MainCamera.Instance.refreshFOV();
	
func _virtualCameraTrackingModified(camera : VirtualCamera):
	if not _isCurrentCamera(camera): return
	
	if camera.tracking.IsTrackingModeNone():
		MainCamera.Instance.disableProcesses()
	else:
		MainCamera.Instance.refreshProcessMethod(camera.processMethod)

func _tryRefreshMainCamera():
	if MainCamera.Instance == null: return
	
	var runningCameras : Array[VirtualCamera] = _virtualCameras.filter(func(camera : VirtualCamera): return camera.enabled)
	
	if runningCameras.size() == 0:
		MainCamera.Instance.trySetVirtualCamera(null);
		return
	
	runningCameras.sort_custom(func(cameraA : VirtualCamera, cameraB : VirtualCamera): return cameraA.priority > cameraB.priority);
	MainCamera.Instance.trySetVirtualCamera(runningCameras[0]);

func _isCurrentCamera(camera : VirtualCamera):
	if MainCamera.Instance == null: return false
	return MainCamera.Instance.isCurrentCamera(camera)
