extends Node

signal onEnabledModified(virtualCamera : VirtualCamera)
signal onPriorityModified(virtualCamera : VirtualCamera)

var _virtualCameras : Array[VirtualCamera]

func _ready():
	onEnabledModified.connect(_virtualCameraEnabledModified)
	onPriorityModified.connect(_virtualCameraPriorityModified)

func addVirtualCamera(virtualCamera : VirtualCamera):
	_virtualCameras.append(virtualCamera)
	
	print("Add Virtual Cameras ", _virtualCameras.size(), " ", virtualCamera.name)
	
	if MainCamera.Instance == null: return
	if not virtualCamera.enabled: return
	
	_virtualCameraEnabledModified(virtualCamera)
	
func removeVirtualCamera(virtualCamera : VirtualCamera):
	_virtualCameras.erase(virtualCamera)
	
	print("Remove Virtual Cameras ", _virtualCameras.size(), " ", virtualCamera.name)
	
	if MainCamera.Instance == null: return
	if not virtualCamera.enabled: return
	
	if MainCamera.Instance.isCurrentCamera(virtualCamera):
		_tryRefreshMainCamera();

func mainCameraStarted():
	print("Main Camera Started")
	_tryRefreshMainCamera();

func _virtualCameraEnabledModified(virtualCamera : VirtualCamera):
	if MainCamera.Instance == null: return

	if virtualCamera.enabled:
		MainCamera.Instance.trySetVirtualCamera(virtualCamera);
	elif MainCamera.Instance.isCurrentCamera(virtualCamera):
		_tryRefreshMainCamera()

func _virtualCameraPriorityModified(virtualCamera : VirtualCamera):
	if MainCamera.Instance == null: return
	if not virtualCamera.enabled: return;
	
	if MainCamera.Instance.isCurrentCamera(virtualCamera):
		_tryRefreshMainCamera()
	else:
		MainCamera.Instance.trySetVirtualCamera(virtualCamera);
	
func _tryRefreshMainCamera():
	if MainCamera.Instance == null: return
	
	var runningCameras : Array[VirtualCamera] = _virtualCameras.filter(func(camera : VirtualCamera): return camera.enabled)
	
	if runningCameras.size() == 0:
		MainCamera.Instance.trySetVirtualCamera(null);
		return
	
	runningCameras.sort_custom(func(cameraA : VirtualCamera, cameraB : VirtualCamera): return cameraA.priority > cameraB.priority);
	print("runningCameras: ", runningCameras)

	print(runningCameras[0].name)
	MainCamera.Instance.trySetVirtualCamera(runningCameras[0]);