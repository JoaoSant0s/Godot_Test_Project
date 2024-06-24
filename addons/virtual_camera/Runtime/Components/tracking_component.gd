@tool
class_name TrackingComponent extends VirtualCameraBaseComponent

@export var target : Node3D
@export var look_at : Node3D

@export var position_control : TypeCameras.PositionControl = TypeCameras.PositionControl.HARD_LOCK_TO_TARGET:
	get:
		return position_control
	set(value):
		position_control = value
		notify_property_list_changed()

@export var rotation_control : TypeCameras.RotationControl = TypeCameras.RotationControl.HARD_LOOK_AT

var tracking_sub_properties : TrackingSubProperties

func _init():
	tracking_sub_properties = TrackingSubProperties.new()

func after_ready():
	pass

func get_radius():
	return tracking_sub_properties.radius

func get_follow_offset():
	var local_position = Vector3.ZERO
	
	match position_control:
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			local_position += tracking_sub_properties.follow_offset
	
	return local_position

func is_position_control_none() -> bool:
	return position_control == TypeCameras.PositionControl.NONE
	
func is_rotation_control_none() -> bool:
	return rotation_control == TypeCameras.RotationControl.NONE

func is_rotation_control_same_as_follow_target() -> bool:
	return rotation_control == TypeCameras.RotationControl.SAME_AS_FOLLOW_TARGET

func get_position() -> Vector3:
	return target.global_position

func build_local_target_direction_offset(offset : Vector3) -> Vector3:
	var forward = target.basis.z
	if forward.x < 0:
		forward *= -1
		offset *= Vector3(-1, 1, -1)

	var angle = forward.angle_to(Vector3.BACK)
	offset = offset.rotated(Vector3.UP, angle)
	
	return offset
	
func get_local_position_control() -> Vector3:
	var local_position = Vector3.ZERO
	
	match position_control:
		TypeCameras.PositionControl.FOLLOW:
			var offset = tracking_sub_properties.follow_offset
			if target != null and tracking_sub_properties.is_local_direction_offset:
				offset = build_local_target_direction_offset(offset)
			
			local_position += offset
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			local_position += tracking_sub_properties.follow_offset
			local_position += _build_radius_position()
	
	return local_position

func get_horizontal_axis_value() -> float:
	return tracking_sub_properties.horizontal_axis_value

func increment_horizontal_axis_value(value : float):
	var angle = tracking_sub_properties.horizontal_axis_value + value
	set_horizontal_axis_value(angle)

func increment_vertical_axis_value(value : float):
	var angle = tracking_sub_properties.vertical_axis_value + value
	set_vertical_axis_value(angle)

func increment_radius(value : float):
	increment(TrackingSubProperties.RADIUS, value)

func set_horizontal_axis_value(angle : float):
	if tracking_sub_properties.is_using_horizontal_range:
		var range = tracking_sub_properties.horizontal_range
		angle = clamp(angle, range.x, range.y)
		
	_set(TrackingSubProperties.HORIZONTAL_AXIS_VALUE, angle)

func set_vertical_axis_value(angle : float):
	if tracking_sub_properties.is_using_vertical_range:
		var range = tracking_sub_properties.vertical_range
		angle = clamp(angle, range.x, range.y)
	
	_set(TrackingSubProperties.VERTICAL_AXIS_VALUE, angle)
	
func _build_radius_position() -> Vector3:
	var radius = tracking_sub_properties.radius

	if _parent != null and _parent.collider != null and _parent.collider.triggered:
		radius = _parent.collider.radius_collider

	var teta_angle = tracking_sub_properties.horizontal_axis_value
	var phi_angle = tracking_sub_properties.vertical_axis_value
	
	var directional_position = MathCameras.bi_angle_to_directional_position(teta_angle, phi_angle)
	
	return directional_position * radius
	
func _get_property_list() -> Array:
	var property_list: Array[Dictionary]
	
	property_list.append_array(tracking_sub_properties.build_properties(self))
	
	return property_list

func _set(property: StringName, value) -> bool:
	var result = tracking_sub_properties.set_property_value(property, value)
	if result:
		notify_property_list_changed()
	
	return result
	
func _get(property):
	return tracking_sub_properties.get_property_value(property)

func increment(property: StringName, value) -> bool:
	var result = tracking_sub_properties.increment_property_value(property, value)
	
	if result:
		notify_property_list_changed()

	return result
