@tool
class_name TrackingComponent extends VirtualCameraBaseComponent

@export var trackingMode: TypeCameras.TrackingMode = TypeCameras.TrackingMode.HARDLOCK:
	get:
		return trackingMode
	set(value):
		trackingMode = value
		if _parent == null: return
		VirtualCameraService.onTrackingComponentModified.emit(_parent)

@export var target : Node3D
@export var lookAt : Node3D

func IsTrackingModeNone() -> bool:
	return trackingMode == TypeCameras.TrackingMode.NONE
