@tool
class_name TrackingComponent extends VirtualCameraBaseComponent

@export var target : Node3D
@export var lookAt : Node3D

var previousHorizontalZ
var previousVerticalZ

@export var positionControl : TypeCameras.PositionControl = TypeCameras.PositionControl.HARD_LOCK_TO_TARGET:
	get:
		return positionControl
	set(value):
		positionControl = value
		notify_property_list_changed()

@export var rotationControl : TypeCameras.RotationControl = TypeCameras.RotationControl.HARD_LOOK_AT

var trackingSubProperties : TrackingSubProperties
var frameCounter : int = 0
var triggeredPreviously : bool = false
var previousRadius : float

func _init():
	trackingSubProperties = TrackingSubProperties.new()

func after_ready():
	previousRadius = get_radius()

func get_radius():
	return trackingSubProperties.radius

func get_follow_offset():
	var localPosition = Vector3.ZERO
	
	match positionControl:
		TypeCameras.PositionControl.FOLLOW:
			localPosition += trackingSubProperties.follow_offset
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			localPosition += trackingSubProperties.follow_offset
	
	return localPosition

func is_position_control_none() -> bool:
	return positionControl == TypeCameras.PositionControl.NONE
	
func is_rotation_control_none() -> bool:
	return rotationControl == TypeCameras.RotationControl.NONE

func is_rotation_control_same_as_follow_target() -> bool:
	return rotationControl == TypeCameras.RotationControl.SAME_AS_FOLLOW_TARGET

func get_position() -> Vector3:
	return target.global_position

func get_local_position_control() -> Vector3:
	var localPosition = Vector3.ZERO
	
	match positionControl:
		TypeCameras.PositionControl.FOLLOW:
			localPosition += trackingSubProperties.follow_offset
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			localPosition += trackingSubProperties.follow_offset
			localPosition += _build_radius_position()
	
	return localPosition

func get_horizontal_axis_value() -> float:
	return trackingSubProperties.horizontal_axis_value

func increment_horizontal_axis_value(value : float):
	var angle = trackingSubProperties.horizontal_axis_value + value
	set_horizontal_axis_value(angle)

func increment_vertical_axis_value(value : float):
	var angle = trackingSubProperties.vertical_axis_value + value
	set_vertical_axis_value(angle)

func increment_radius(value : float):
	increment(TrackingSubProperties.RADIUS, value)

func set_horizontal_axis_value(angle : float):
	if trackingSubProperties.is_using_horizontal_range:
		var range = trackingSubProperties.horizontal_range
		angle = clamp(angle, range.x, range.y)
		
	_set(TrackingSubProperties.HORIZONTAL_AXIS_VALUE, angle)

func set_vertical_axis_value(angle : float):
	if trackingSubProperties.is_using_vertical_range:
		var range = trackingSubProperties.vertical_range
		angle = clamp(angle, range.x, range.y)
	
	_set(TrackingSubProperties.VERTICAL_AXIS_VALUE, angle)
	
func _build_radius_position() -> Vector3:
	var radius = trackingSubProperties.radius

	if _parent != null and _parent.collider != null and _parent.collider.triggered:
		radius = _parent.collider.radiusCollider

	var tetaAngle = trackingSubProperties.horizontal_axis_value
	var phiAngle = trackingSubProperties.vertical_axis_value
	
	var cosPhi =  cos(deg_to_rad(phiAngle))
	
	var x = cosPhi * sin(deg_to_rad(tetaAngle))
	var y = sin(deg_to_rad(phiAngle))
	var z = cosPhi * cos(deg_to_rad(tetaAngle))
	
	return Vector3(x, y, z) * radius
	
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

func increment(property: StringName, value) -> bool:
	var result = trackingSubProperties.increment_property_value(property, value)
	
	if result:
		notify_property_list_changed()

	return result
