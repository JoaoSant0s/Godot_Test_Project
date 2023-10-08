@tool
class_name TrackingComponent extends VirtualCameraBaseComponent

@export var target : Node3D
@export var lookAt : Node3D

@export var positionControl : TypeCameras.PositionControl = TypeCameras.PositionControl.HARD_LOCK_TO_TARGET
@export var rotationControl : TypeCameras.RotationControl = TypeCameras.RotationControl.HARD_LOOK_AT

func IsPositionControlNone() -> bool:
	return positionControl == TypeCameras.PositionControl.NONE
	
func IsRotationControlNone() -> bool:
	return rotationControl == TypeCameras.RotationControl.NONE
