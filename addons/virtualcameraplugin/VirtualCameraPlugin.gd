@tool
extends EditorPlugin

const AUTOLOAD_CAMERA_SERVICE = "VirtualCameraService"
const VIRTUAL_CAMERA_NAME = "VirtualCamera"
const MAIN_CAMERA_NAME = "MainCamera"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_CAMERA_SERVICE, "res://addons/virtualcameraplugin/VirtualCamera/Runtime/VirtualCameraService.gd")
	add_custom_type(MAIN_CAMERA_NAME, "Camera3D", preload("VirtualCamera/Runtime/MainCamera.gd"), preload("VirtualCamera/Icons/camera-main.svg"))
	add_custom_type(VIRTUAL_CAMERA_NAME, "Node3D", preload("VirtualCamera/Runtime/VirtualCamera.gd"), preload("VirtualCamera/Icons/camera-virtual.svg"))
	
func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_CAMERA_SERVICE)
	remove_custom_type(MAIN_CAMERA_NAME)
	remove_custom_type(VIRTUAL_CAMERA_NAME)
