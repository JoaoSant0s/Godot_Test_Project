@tool
class_name VirtualCameraBaseComponent extends Node

var _parent : VirtualCamera = null
	
func _ready():
	if not get_parent() is VirtualCamera: return
	
	_parent = get_parent() as VirtualCamera
	assert(_parent is VirtualCamera, "This Component must be a Node of a VirtualCamera")
