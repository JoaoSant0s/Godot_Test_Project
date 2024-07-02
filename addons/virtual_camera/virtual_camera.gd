@tool
class_name VirtualCameraPlugin extends EditorPlugin

const AUTOLOAD_CAMERA_SERVICE = "VirtualCameraService"
const VIRTUAL_CAMERA_NAME = "VirtualCamera"
const MAIN_CAMERA_NAME = "MainCamera"

var dock

static var Instance;

func _enter_tree():
	Instance = self
	add_autoload_singleton(AUTOLOAD_CAMERA_SERVICE, "res://addons/virtual_camera/runtime/virtual_camera_service.gd")
	add_custom_type(MAIN_CAMERA_NAME, "Camera3D", preload("res://addons/virtual_camera/runtime/main_camera.gd"), preload("res://addons/virtual_camera/icons/camera-main.svg"))
	add_custom_type(VIRTUAL_CAMERA_NAME, "Node3D", preload("res://addons/virtual_camera/runtime/virtual_camera.gd"), preload("res://addons/virtual_camera/icons/camera-virtual.svg"))
	
	dock = preload("res://addons/virtual_camera/prefabs/VirtualCameraDock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BR, dock)
	
func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_CAMERA_SERVICE)
	remove_custom_type(MAIN_CAMERA_NAME)
	remove_custom_type(VIRTUAL_CAMERA_NAME)
	remove_control_from_docks(dock)
	dock.free()

func clear_selection():
	get_editor_interface().get_selection().clear()

func add_node(node):
	get_editor_interface().get_selection().add_node(node)

func get_selected_virtual_camera() -> VirtualCamera:
	var selected_nodes = get_editor_interface().get_selection().get_selected_nodes()
	
	if selected_nodes.size() == 0: return null
	var first_node = selected_nodes[0]
	
	if first_node is VirtualCamera: return first_node as VirtualCamera
	
	return null
