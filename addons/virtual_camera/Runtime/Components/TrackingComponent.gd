@tool
class_name TrackingComponent extends VirtualCameraBaseComponent

@export var target : Node3D
@export var lookAt : Node3D

@export var positionControl : TypeCameras.PositionControl = TypeCameras.PositionControl.HARD_LOCK_TO_TARGET:
	get:
		return positionControl
	set(value):
		positionControl = value
		notify_property_list_changed()

@export var rotationControl : TypeCameras.RotationControl = TypeCameras.RotationControl.HARD_LOOK_AT

var trackingSubProperties : TrackingSubProperties

func _init():
	trackingSubProperties = TrackingSubProperties.new()

func IsPositionControlNone() -> bool:
	return positionControl == TypeCameras.PositionControl.NONE
	
func IsRotationControlNone() -> bool:
	return rotationControl == TypeCameras.RotationControl.NONE

func IsRotationControlSameAsFollowTarget() -> bool:
	return rotationControl == TypeCameras.RotationControl.SAME_AS_FOLLOW_TARGET

func GetPosition() -> Vector3:
	var position = target.global_position

	if positionControl == TypeCameras.PositionControl.FOLLOW:
		position += trackingSubProperties.get_property_value(TrackingSubProperties.FOLLOWOFFSET)

	return position
	
func _get_property_list() -> Array:
	var property_list: Array[Dictionary]
	
	property_list.append_array(trackingSubProperties.build_properties(self))
	
	return property_list

func _set(property: StringName, value) -> bool:
	var result = trackingSubProperties.set_property_value(property, value)
	if result:
		notify_property_list_changed()
	
	return result	
	
func _get(property):
	return trackingSubProperties.get_property_value(property)
