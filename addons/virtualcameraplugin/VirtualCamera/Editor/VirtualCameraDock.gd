@tool
class_name Name extends Node

@export var selectEnabledVirtualCameras : Button
@export var selectAllVirtualCameras : Button
@export var selectMainCamera : Button

func _ready():
	selectEnabledVirtualCameras.pressed.connect(onEnabledVirtualCameras)
	selectAllVirtualCameras.pressed.connect(onSelectAllVirtualCameras)
	selectMainCamera.pressed.connect(onSelectMainCamera)

func onEnabledVirtualCameras():
	VirtualCameraPlugin.Instance.ClearSelection();
	var virtualCameras = VirtualCameraService.findEnabledVirtualCameras();
	
	print("Found ", virtualCameras.size(), " Enabled Virtual Cameras")

	for camera in virtualCameras:
		VirtualCameraPlugin.Instance.AddNode(camera)

func onSelectAllVirtualCameras():
	VirtualCameraPlugin.Instance.ClearSelection();
	var virtualCameras = VirtualCameraService.findVirtualCameras();
	
	print("Found ", virtualCameras.size(), " Virtual Cameras")

	for camera in virtualCameras:
		VirtualCameraPlugin.Instance.AddNode(camera)

func onSelectMainCamera():
	assert(MainCamera.Instance != null, "Must Create first a MainCamera Component in the scene")
	VirtualCameraPlugin.Instance.AddNode(MainCamera.Instance)
