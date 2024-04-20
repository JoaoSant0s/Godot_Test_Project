@tool
class_name ColliderComponent extends VirtualCameraBaseComponent

@export_category("Obstacle Detection")
@export var strategy : TypeCameras.ObstacleDetectionStrategy = TypeCameras.ObstacleDetectionStrategy.PULL_CAMERA_FORWARD

func after_ready():
	_parent.collider = self
