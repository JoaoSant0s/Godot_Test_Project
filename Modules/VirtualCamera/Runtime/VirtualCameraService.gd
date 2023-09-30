extends Node

var _virtualCameras : Array[VirtualCamera]

func addVirtualCamera(virtualCamera : VirtualCamera):
	_virtualCameras.append(virtualCamera)
	print("Add Virtual Cameras ", _virtualCameras.size(), " ", virtualCamera.name)
	
func removeVirtualCamera(virtualCamera : VirtualCamera):
	_virtualCameras.erase(virtualCamera)
	print("Remove Virtual Cameras ", _virtualCameras.size(), " ", virtualCamera.name)

func mainCameraStarted():
	print("Main Camera Started")
	_tryRefreshMainCamera();
	
func _tryRefreshMainCamera():
	var currentCamera = _virtualCameras[0];
	print(currentCamera.name)
	MainCamera.Instance.setVirtualCamera(currentCamera);
