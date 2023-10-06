@tool
class_name VirtualCameraBaseComponent extends Node

var _parent : VirtualCamera = null

func _ready():
	if not get_parent() is VirtualCamera: return
	
	_parent = get_parent() as VirtualCamera
