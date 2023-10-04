@tool
class_name VirtualCameraPlugin extends EditorPlugin

const AUTOLOAD_CAMERA_SERVICE = "VirtualCameraService"
const VIRTUAL_CAMERA_NAME = "VirtualCamera"
const MAIN_CAMERA_NAME = "MainCamera"

var dock

static var Instance;

func _enter_tree():
	Instance = self
	add_autoload_singleton(AUTOLOAD_CAMERA_SERVICE, "res://addons/virtualcameraplugin/VirtualCamera/Runtime/VirtualCameraService.gd")
	add_custom_type(MAIN_CAMERA_NAME, "Camera3D", preload("res://addons/virtualcameraplugin/VirtualCamera/Runtime/MainCamera.gd"), preload("res://addons/virtualcameraplugin/VirtualCamera/Icons/camera-main.svg"))
	add_custom_type(VIRTUAL_CAMERA_NAME, "Node3D", preload("res://addons/virtualcameraplugin/VirtualCamera/Runtime/VirtualCamera.gd"), preload("res://addons/virtualcameraplugin/VirtualCamera/Icons/camera-virtual.svg"))
	
	dock = preload("res://addons/virtualcameraplugin/VirtualCamera/Prefabs/VirtualCameraDock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)
	
func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_CAMERA_SERVICE)
	remove_custom_type(MAIN_CAMERA_NAME)
	remove_custom_type(VIRTUAL_CAMERA_NAME)
	remove_control_from_docks(dock)
	dock.free()

func ClearSelection():
	get_editor_interface().get_selection().clear()

func AddNode(node):
	get_editor_interface().get_selection().add_node(node)
