class_name ColliderSubProperties extends SubProperties

const TRANSITION_SPEED : StringName  = "transition_speed"
const TRANSITION_ENABLED : StringName  = "transition_enabled"

var transition_speed : float:
	get:
		return get_property_value(TRANSITION_SPEED)

var transition_enabled : bool:
	get:
		return get_property_value(TRANSITION_ENABLED)

func _init():
	properties[TRANSITION_SPEED] = 10.0
	properties[TRANSITION_ENABLED] = false

func build_properties(component : VirtualCameraBaseComponent) -> Array:
	var property_list: Array[Dictionary]
	
	var collider = component as ColliderComponent
	
	match collider.strategy:
		TypeCameras.ObstacleDetectionStrategy.PULL_CAMERA_FORWARD:
			build_pull_camera_forward_properties(property_list)
		
	return property_list

func build_pull_camera_forward_properties(property_list: Array[Dictionary]):
	property_list.append({
		"name": "Pull Camera Forward",
		"type": TYPE_STRING_NAME,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	property_list.append({
		"name": TRANSITION_ENABLED,
		"type": TYPE_BOOL
	})
	
	if properties.has(TRANSITION_ENABLED) and properties[TRANSITION_ENABLED]:
		property_list.append({
			"name": TRANSITION_SPEED,
			"type": TYPE_FLOAT,
		})
