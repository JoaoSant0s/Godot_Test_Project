@tool
class_name LensComponent extends Node

var parent : VirtualCamera = null

@export_range(1, 179, 0.5) var fov: float = 75:
	get:
		return fov
	set(value):
		fov = value
		assert(parent != null, "The LensComponent must be a Node of a VirtualCamera")
		if parent == null: return
		VirtualCameraService.onLensCompoenentModified.emit(parent)

func _ready():
	if get_parent() is VirtualCamera:
		parent = get_parent() as VirtualCamera

