@tool
class_name LensComponent extends VirtualCameraBaseComponent

@export_range(1, 179, 0.5) var fov: float = 75:
	get:
		return fov
	set(value):
		fov = value
		if _parent == null: return
		VirtualCameraService.onLensComponentModified.emit(_parent)
