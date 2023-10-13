@tool
class_name Name extends Node

@export var selectEnabledVirtualCameras : Button
@export var selectAllVirtualCameras : Button
@export var selectMainCamera : Button
@export var forceActiveSelectedCamera : Button

func _ready():
	selectEnabledVirtualCameras.pressed.connect(onEnabledVirtualCameras)
	selectAllVirtualCameras.pressed.connect(onSelectAllVirtualCameras)
	selectMainCamera.pressed.connect(onSelectMainCamera)
	forceActiveSelectedCamera.pressed.connect(onForceActiveCamera)

func onEnabledVirtualCameras():
	VirtualCameraPlugin.Instance.clearSelection();
	var virtualCameras = VirtualCameraService.findEnabledVirtualCameras();
	
	print("Found ", virtualCameras.size(), " Enabled Virtual Cameras")

	for camera in virtualCameras:
		VirtualCameraPlugin.Instance.addNode(camera)

func onSelectAllVirtualCameras():
	VirtualCameraPlugin.Instance.clearSelection();
	var virtualCameras = VirtualCameraService.findVirtualCameras();
	
	print("Found ", virtualCameras.size(), " Virtual Cameras")

	for camera in virtualCameras:
		VirtualCameraPlugin.Instance.addNode(camera)

func onSelectMainCamera():
	assert(MainCamera.Instance != null, "Must Create first a MainCamera Component in the scene")
	VirtualCameraPlugin.Instance.addNode(MainCamera.Instance)

func onForceActiveCamera():
	var selectedCamera = VirtualCameraPlugin.Instance.getSelectedVirtualCamera()
	if selectedCamera == null: return
	
	selectedCamera.forceActiveCamera()
