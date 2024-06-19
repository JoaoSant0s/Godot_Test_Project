class_name TrackingSubProperties extends SubProperties

const FOLLOW_OFFSET : StringName  = "followOffset"
const LOCAL_DIRECTION_OFFSET : StringName = "localDirectionOffset"
const RADIUS : StringName = "radius"

const HORIZONTAL_AXIS_VALUE : StringName = "horizontalAxisValue"
const HORIZONTAL_AXIS_USING_RANGE : StringName = "horizontalAxisUsingRange"
const HORIZONTAL_AXIS_RANGE : StringName = "horizontalAxisRange"

const VERTICAL_AXIS_VALUE : StringName = "verticalAxisValue"
const VERTICAL_AXIS_USING_RANGE : StringName = "verticalAxisUsingRange"
const VERTICAL_AXIS_RANGE : StringName = "verticalAxisRange"

var radius : float:
	get:
		return get_property_value(RADIUS)

var horizontal_axis_value : float:
	get:
		return get_property_value(HORIZONTAL_AXIS_VALUE)

var vertical_axis_value : float:
	get:
		return get_property_value(VERTICAL_AXIS_VALUE)

var follow_offset : Vector3:
	get:
		return get_property_value(FOLLOW_OFFSET)

var is_local_direction_offset : bool:
	get:
		return get_property_value(LOCAL_DIRECTION_OFFSET)

var is_using_horizontal_range : bool:
	get:
		return get_property_value(HORIZONTAL_AXIS_USING_RANGE)

var is_using_vertical_range : bool:
	get:
		return get_property_value(VERTICAL_AXIS_USING_RANGE)
		
var horizontal_range: Vector2:
	get:
		return get_property_value(HORIZONTAL_AXIS_RANGE)

var vertical_range: Vector2:
	get:
		return get_property_value(VERTICAL_AXIS_RANGE)

func _init():
	properties[FOLLOW_OFFSET] = Vector3.ZERO
	properties[LOCAL_DIRECTION_OFFSET] = false
	properties[RADIUS] = 0.0

	properties[HORIZONTAL_AXIS_VALUE] = 0.0
	properties[HORIZONTAL_AXIS_USING_RANGE] = false
	properties[HORIZONTAL_AXIS_RANGE] = Vector2.ZERO
		
	properties[VERTICAL_AXIS_VALUE] = 0.0
	properties[VERTICAL_AXIS_USING_RANGE] = false
	properties[VERTICAL_AXIS_RANGE] = Vector2.ZERO

func build_properties(component : VirtualCameraBaseComponent) -> Array:
	var tracking = component as TrackingComponent
	
	var property_list: Array[Dictionary]
	
	match tracking.positionControl:
		TypeCameras.PositionControl.FOLLOW:
			build_follow_properties(property_list)
		TypeCameras.PositionControl.ORBITAL_FOLLOW:
			build_orbital_properties(property_list)
		
	return property_list
	
func build_follow_properties(property_list: Array[Dictionary]):
	property_list.append({
		"name": "Follow",
		"type": TYPE_STRING_NAME,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	property_list.append({
		"name": FOLLOW_OFFSET,
		"type": TYPE_VECTOR3,
	})
	
	property_list.append({
		"name": LOCAL_DIRECTION_OFFSET,
		"type": TYPE_BOOL,
	})

func build_orbital_properties(property_list: Array[Dictionary]):
	property_list.append({
		"name": "Orbital Follow",
		"type": TYPE_STRING_NAME,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	property_list.append({
		"name": FOLLOW_OFFSET,
		"type": TYPE_VECTOR3,
	})
	
	property_list.append({
		"name": LOCAL_DIRECTION_OFFSET,
		"type": TYPE_BOOL,
	})
	
	property_list.append({
		"name": RADIUS,
		"type": TYPE_FLOAT,
	})
	
	property_list.append({
		"name": "Horizontal Axis",
		"type": TYPE_STRING_NAME,
		"usage": PROPERTY_USAGE_SUBGROUP
	})
	
	property_list.append({
		"name": HORIZONTAL_AXIS_VALUE,
		"type": TYPE_FLOAT
	})
	
	property_list.append({
		"name": HORIZONTAL_AXIS_USING_RANGE,
		"type": TYPE_BOOL
	})
	
	if properties.has(HORIZONTAL_AXIS_USING_RANGE) and properties[HORIZONTAL_AXIS_USING_RANGE]:
		property_list.append({
			"name": HORIZONTAL_AXIS_RANGE,
			"type": TYPE_VECTOR2
		})
	
	property_list.append({
		"name": "Vertical Axis",
		"type": TYPE_STRING_NAME,
		"usage": PROPERTY_USAGE_SUBGROUP
	})
	
	property_list.append({
		"name": VERTICAL_AXIS_VALUE,
		"type": TYPE_FLOAT
	})
	
	property_list.append({
		"name": VERTICAL_AXIS_USING_RANGE,
		"type": TYPE_BOOL
	})
	
	if properties.has(VERTICAL_AXIS_USING_RANGE) and properties[VERTICAL_AXIS_USING_RANGE]:
		property_list.append({
			"name": VERTICAL_AXIS_RANGE,
			"type": TYPE_VECTOR2
		})
