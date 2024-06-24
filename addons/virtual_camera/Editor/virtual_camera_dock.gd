@tool
class_name Name extends Node

@export var select_enabled_virtual_cameras : Button
@export var select_all_virtual_cameras : Button
@export var select_main_camera : Button
@export var force_active_selected_camera : Button

@export var select_virtual_camera_with_tag : Button
@export var virtual_camera_tag_input : LineEdit

@export var select_virtual_cameras_with_group : Button
@export var virtual_camera_group_input : LineEdit

func _ready():
	select_enabled_virtual_cameras.pressed.connect(_on_enabled_virtual_cameras)
	select_all_virtual_cameras.pressed.connect(_on_select_all_virtual_cameras)
	select_main_camera.pressed.connect(_on_select_main_camera)
	force_active_selected_camera.pressed.connect(_on_force_active_camera)
	
	select_virtual_camera_with_tag.pressed.connect(_on_select_virtual_camera_with_tag)
	select_virtual_cameras_with_group.pressed.connect(_on_select_virtual_cameras_with_group)

func _on_enabled_virtual_cameras():
	VirtualCameraPlugin.Instance.clear_selection();
	var virtualCameras = VirtualCameraService.find_enabled_virtual_cameras();
	
	print("Found ", virtualCameras.size(), " Enabled Virtual Cameras")

	for camera in virtualCameras:
		VirtualCameraPlugin.Instance.add_node(camera)

func _on_select_all_virtual_cameras():
	VirtualCameraPlugin.Instance.clear_selection();
	var virtualCameras = VirtualCameraService.find_virtual_cameras();
	
	print("Found ", virtualCameras.size(), " Virtual Cameras")

	for camera in virtualCameras:
		VirtualCameraPlugin.Instance.add_node(camera)

func _on_select_main_camera():	
	assert(VirtualCameraService.is_main_camera_available(), "Must Create first a MainCamera Component in the scene")
	VirtualCameraPlugin.Instance.add_node(VirtualCameraService.get_main_camera())

func _on_force_active_camera():
	var selectedCamera = VirtualCameraPlugin.Instance.get_selected_virtual_camera()
	if selectedCamera == null: return
	
	selectedCamera.force_active_camera()
	
func _on_select_virtual_camera_with_tag():
	VirtualCameraPlugin.Instance.clear_selection()
	var tagInput = virtual_camera_tag_input.text

	var selectedCameras = _filter_cameras_by_tag(tagInput)
	
	if selectedCameras.size() == 0:
		print("Can't found a Virtual Camera with Tag ", tagInput)
		return
	
	print("Found ", selectedCameras.size(), " Virtual Cameras with Tag ", tagInput)
	for camera in selectedCameras:
		VirtualCameraPlugin.Instance.add_node(camera)

func _on_select_virtual_cameras_with_group():
	VirtualCameraPlugin.Instance.clear_selection()
	var groupInput = virtual_camera_group_input.text

	var selectedCameras = _filter_cameras_by_group(groupInput)
	
	if selectedCameras.size() == 0:
		print("Can't found a Virtual Camera with Group ", groupInput)
		return
	
	print("Found ", selectedCameras.size(), " Virtual Cameras with Group ", groupInput)
	for camera in selectedCameras:
		VirtualCameraPlugin.Instance.add_node(camera)

func _filter_cameras_by_tag(tagInput : String) -> Array[VirtualCamera]:
	var virtualCameras = VirtualCameraService.find_virtual_cameras()
	
	var filterAction = func(camera : VirtualCamera):
		if camera.tag == null: return false
		return tagInput == UtilsCamera.extract_resource_name(camera.tag)

	return virtualCameras.filter(filterAction)

func _filter_cameras_by_group(groupInput : String) -> Array[VirtualCamera]:
	var virtualCameras = VirtualCameraService.find_virtual_cameras()
	
	var filterAction = func(camera : VirtualCamera):
		if camera.group == null: return false
		return groupInput == UtilsCamera.extract_resource_name(camera.group)

	return virtualCameras.filter(filterAction)
