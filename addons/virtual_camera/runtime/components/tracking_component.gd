@tool
class_name TrackingComponent extends VirtualCameraBaseComponent

const GROUP_FOLLOW : StringName = "Follow"
const GROUP_ORBITAL_FOLLOW : StringName = "Orbital Follow"

const FOLLOW_OFFSET : StringName  = "follow_offset"
const IS_LOCAL_DIRECTION_OFFSET : StringName = "is_local_diretion_offset"
const RADIUS : StringName = "radius"

const SUBGROUP_HORIZONTAL_AXIS : StringName = "Horizontal Axis"
const SUBGROUP_VERTICAL_AXIS : StringName = "Vertical Axis"

const HORIZONTAL_AXIS_VALUE : StringName = "horizontal_axis_value"
const IS_USING_HORIZONTAL_AXIS_RANGE : StringName = "is_using_horizontal_axis_range"
const HORIZONTAL_AXIS_RANGE : StringName = "horizontal_axis_range"

const VERTICAL_AXIS_VALUE : StringName = "vertical_axis_value"
const IS_USING_VERTICAL_AXIS_RANGE : StringName = "is_using_vertical_axis_range"
const VERTICAL_AXIS_RANGE : StringName = "vertical_axis_range"

const SUBGROUP_PATHS : StringName = "Paths"
const PATH : StringName = "path"
const PATH_FOLLOW : StringName = "path_follow"
const IS_TILT_ROTATE_ON_PATH : StringName = "tilt_rotate_on_path"
const TILT_ROTATE_ANGLE_ON_PATH : StringName = "tilt_rotate_angle_on_path"

const VALIDATE_PROPERTY_NAMES = [
	GROUP_FOLLOW, GROUP_ORBITAL_FOLLOW,
	SUBGROUP_HORIZONTAL_AXIS, SUBGROUP_VERTICAL_AXIS,
	FOLLOW_OFFSET, IS_LOCAL_DIRECTION_OFFSET, RADIUS,
	
	HORIZONTAL_AXIS_VALUE, IS_USING_HORIZONTAL_AXIS_RANGE, HORIZONTAL_AXIS_RANGE,
	VERTICAL_AXIS_VALUE, IS_USING_VERTICAL_AXIS_RANGE, VERTICAL_AXIS_RANGE,
	
	SUBGROUP_PATHS, PATH, PATH_FOLLOW, IS_TILT_ROTATE_ON_PATH, TILT_ROTATE_ANGLE_ON_PATH
]

@export var target : Node3D
@export var look_at : Node3D

@export var position_control : TypeCameras.PositionControl = TypeCameras.PositionControl.HARD_LOCK_TO_TARGET:
	get:
		return position_control
	set(value):
		position_control = value
		notify_property_list_changed()

@export var rotation_control : TypeCameras.RotationControl = TypeCameras.RotationControl.HARD_LOOK_AT

@export_group(GROUP_FOLLOW)
@export_group(GROUP_ORBITAL_FOLLOW)

@export var follow_offset : Vector3 =  Vector3.ZERO
@export var is_local_diretion_offset : bool = false
@export var radius : float = 3.0

@export_subgroup(SUBGROUP_HORIZONTAL_AXIS)

@export var horizontal_axis_value = 0.0
@export var is_using_horizontal_axis_range = false:
	get:
		return is_using_horizontal_axis_range
	set(value):
		is_using_horizontal_axis_range = value
		notify_property_list_changed()

@export var horizontal_axis_range = Vector2.ZERO

@export_subgroup(SUBGROUP_VERTICAL_AXIS)

@export var vertical_axis_value = 0.0
@export var is_using_vertical_axis_range = false:
	get:
		return is_using_vertical_axis_range
	set(value):
		is_using_vertical_axis_range = value
		notify_property_list_changed()

@export var vertical_axis_range = Vector2.ZERO

@export_subgroup(SUBGROUP_PATHS)

@export var path : Path3D
@export var path_follow : PathFollow3D
@export var tilt_rotate_on_path = true:
	get:
		return tilt_rotate_on_path
	set(value):
		tilt_rotate_on_path = value
		notify_property_list_changed()

@export var tilt_rotate_angle_on_path : Vector3

func after_ready():
	pass

func _validate_property(property: Dictionary):
	_reset_follow_properties(property)
	
	match position_control:
		TypeCameras.PositionControl.FOLLOW:
			_validate_follow_properties(property)
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			_validate_orbital_properties(property)
		TypeCameras.PositionControl.PATH_FOLLOW:
			_validate_follow_properties(property)
			_validate_path_follow_properties(property)

func get_follow_offset():
	var local_position = Vector3.ZERO
	
	match position_control:
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			local_position += follow_offset
	
	return local_position

func is_position_control_none() -> bool:
	return position_control == TypeCameras.PositionControl.NONE
	
func is_rotation_control_none() -> bool:
	return rotation_control == TypeCameras.RotationControl.NONE

func is_rotation_control_same_as_follow_target() -> bool:
	return rotation_control == TypeCameras.RotationControl.SAME_AS_FOLLOW_TARGET

func is_tilt_rotate_on_path() -> bool:
	return position_control == TypeCameras.PositionControl.PATH_FOLLOW and tilt_rotate_on_path

func get_position() -> Vector3:
	if target:
		match position_control:
			TypeCameras.PositionControl.PATH_FOLLOW:
				var offset : float = path.curve.get_closest_offset(target.global_position * path.transform)
				path_follow.progress = offset
				return path_follow.global_position
			_:
				return target.global_position
	else:
		match position_control:
			TypeCameras.PositionControl.PATH_FOLLOW:
				return path_follow.global_position
			_:
				return _parent.global_position

func build_local_target_direction_offset(reference : Node3D, offset : Vector3) -> Vector3:
	var forward = reference.basis.z
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
			var offset = follow_offset
			if target != null and is_local_diretion_offset:
				offset = build_local_target_direction_offset(target, offset)
			
			local_position += offset
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			local_position += follow_offset
			local_position += _build_radius_position()
		TypeCameras.PositionControl.PATH_FOLLOW:
			var offset = follow_offset
			if is_local_diretion_offset:
				offset = build_local_target_direction_offset(path_follow, offset)
			
			local_position += offset
	
	return local_position

func increment_horizontal_axis_value(value : float):	
	set_horizontal_axis_value(horizontal_axis_value + value)

func increment_vertical_axis_value(value : float):
	set_vertical_axis_value(vertical_axis_value + value)

func increment_radius(value : float):
	radius += value

func set_horizontal_axis_value(angle : float):
	if is_using_horizontal_axis_range:
		var range = horizontal_axis_range
		angle = clamp(angle, range.x, range.y)
	
	horizontal_axis_value = angle

func set_vertical_axis_value(angle : float):
	if is_using_vertical_axis_range:
		var range = vertical_axis_range
		angle = clamp(angle, range.x, range.y)
	
	vertical_axis_value = angle	
	
func _build_radius_position() -> Vector3:
	var local_radius = radius

	if _parent != null and _parent.collider != null and _parent.collider.triggered:
		local_radius = _parent.collider.radius_collider
	
	var directional_position = MathCameras.bi_angle_to_directional_position(horizontal_axis_value, vertical_axis_value)
	
	return directional_position * local_radius

func _reset_follow_properties(property : Dictionary):	
	if VALIDATE_PROPERTY_NAMES.has(property.name):
		property.usage = PROPERTY_USAGE_NONE

func _validate_follow_properties(property: Dictionary):
	if property.name == GROUP_FOLLOW:
		property.usage = PROPERTY_USAGE_GROUP
	
	if property.name == FOLLOW_OFFSET or property.name == IS_LOCAL_DIRECTION_OFFSET:
		property.usage = SUB_PROPERTY_USAGE_VALUE

func _validate_orbital_properties(property: Dictionary):
	var name = property.name
	if name == GROUP_ORBITAL_FOLLOW:
		property.usage = PROPERTY_USAGE_GROUP
		
	if name == FOLLOW_OFFSET or name == IS_LOCAL_DIRECTION_OFFSET or name == RADIUS:
		property.usage = SUB_PROPERTY_USAGE_VALUE
		
	if name == SUBGROUP_HORIZONTAL_AXIS or name == SUBGROUP_VERTICAL_AXIS:
		property.usage = PROPERTY_USAGE_SUBGROUP 

	if name == HORIZONTAL_AXIS_VALUE or name == IS_USING_HORIZONTAL_AXIS_RANGE or (name == HORIZONTAL_AXIS_RANGE and is_using_horizontal_axis_range):
		property.usage = SUB_PROPERTY_USAGE_VALUE
		
	if name == VERTICAL_AXIS_VALUE or name == IS_USING_VERTICAL_AXIS_RANGE or (name == VERTICAL_AXIS_RANGE and is_using_vertical_axis_range):
		property.usage = SUB_PROPERTY_USAGE_VALUE

func _validate_path_follow_properties(property: Dictionary):
	var name = property.name
	
	if name == SUBGROUP_PATHS:
		property.usage = PROPERTY_USAGE_GROUP
		
	if name == PATH or name == PATH_FOLLOW or name == IS_TILT_ROTATE_ON_PATH:
		property.usage = SUB_PROPERTY_USAGE_VALUE
		
	if name == TILT_ROTATE_ANGLE_ON_PATH and tilt_rotate_on_path:
		property.usage = SUB_PROPERTY_USAGE_VALUE
		
