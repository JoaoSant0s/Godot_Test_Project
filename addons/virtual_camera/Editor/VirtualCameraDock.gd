@tool
class_name Name extends Node

@export var selectEnabledVirtualCameras : Button
@export var selectAllVirtualCameras : Button
@export var selectMainCamera : Button
@export var forceActiveSelectedCamera : Button

@export var selectVirtualCameraWithTag : Button
@export var virtualCameraTagInput : LineEdit

@export var selectVirtualCamerasWithGroup : Button
@export var virtualCameraGroupInput : LineEdit

func _ready():
	selectEnabledVirtualCameras.pressed.connect(onEnabledVirtualCameras)
	selectAllVirtualCameras.pressed.connect(onSelectAllVirtualCameras)
	selectMainCamera.pressed.connect(onSelectMainCamera)
	forceActiveSelectedCamera.pressed.connect(onForceActiveCamera)
	
	selectVirtualCameraWithTag.pressed.connect(onSelectVirtualCameraWithTag)
	selectVirtualCamerasWithGroup.pressed.connect(onSelectVirtualCamerasWithGroup)

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
	assert(VirtualCameraService.isMainCameraAvailable(), "Must Create first a MainCamera Component in the scene")
	VirtualCameraPlugin.Instance.addNode(VirtualCameraService.getMainCamera())

func onForceActiveCamera():
	var selectedCamera = VirtualCameraPlugin.Instance.getSelectedVirtualCamera()
	if selectedCamera == null: return
	
	selectedCamera.forceActiveCamera()
	
func onSelectVirtualCameraWithTag():
	VirtualCameraPlugin.Instance.clearSelection()
	var tagInput = virtualCameraTagInput.text

	var selectedCameras = _filterCamerasByTag(tagInput)
	
	if selectedCameras.size() == 0:
		print("Can't found a Virtual Camera with Tag ", tagInput)
		return
	
	print("Found ", selectedCameras.size(), " Virtual Cameras with Tag ", tagInput)
	for camera in selectedCameras:
		VirtualCameraPlugin.Instance.addNode(camera)

func onSelectVirtualCamerasWithGroup():
	VirtualCameraPlugin.Instance.clearSelection()
	var groupInput = virtualCameraGroupInput.text

	var selectedCameras = _filterCamerasByGroup(groupInput)
	
	if selectedCameras.size() == 0:
		print("Can't found a Virtual Camera with Group ", groupInput)
		return
	
	print("Found ", selectedCameras.size(), " Virtual Cameras with Group ", groupInput)
	for camera in selectedCameras:
		VirtualCameraPlugin.Instance.addNode(camera)

func _filterCamerasByTag(tagInput : String) -> Array[VirtualCamera]:
	var virtualCameras = VirtualCameraService.findVirtualCameras()
	
	var filterAction = func(camera : VirtualCamera):
		if camera.tag == null: return false
		return tagInput == UtilsCamera.extractResourceName(camera.tag)

	return virtualCameras.filter(filterAction)

func _filterCamerasByGroup(groupInput : String) -> Array[VirtualCamera]:
	var virtualCameras = VirtualCameraService.findVirtualCameras()
	
	var filterAction = func(camera : VirtualCamera):
		if camera.group == null: return false
		return groupInput == UtilsCamera.extractResourceName(camera.group)

	return virtualCameras.filter(filterAction)
