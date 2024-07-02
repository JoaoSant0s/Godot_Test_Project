@tool
class_name LensComponent extends VirtualCameraBaseComponent

@export_range(1, 179, 0.5) var fov: float = 75

@export_flags_3d_render var cull_mask := 1048575:
	get:
		return cull_mask
	set(value):
		cull_mask = value
		if _parent == null:
			return
		VirtualCameraService.refresh_cull_mask()

func after_ready():
	VirtualCameraService.refresh_cull_mask()
