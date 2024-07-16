@tool
class_name VirtualCameraBaseComponent extends Node

const SUB_PROPERTY_USAGE_VALUE : int = PROPERTY_USAGE_STORAGE + PROPERTY_USAGE_EDITOR + PROPERTY_USAGE_SCRIPT_VARIABLE
var _parent : VirtualCamera = null
var _is_ready : bool = false

func _ready():
	if not get_parent() is VirtualCamera: return
	
	_parent = get_parent() as VirtualCamera
	assert(_parent is VirtualCamera, "This Component must be a Node of a VirtualCamera")
	after_ready()
	_is_ready = true

func after_ready():
	pass

func is_component_ready() -> bool:
	return _is_ready
