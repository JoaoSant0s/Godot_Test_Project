class_name TrackingSubProperties extends SubProperties

const FOLLOW_OFFSET : StringName  = "followOffset"
const RADIUS : StringName = "radius"

const HORIZONTAL_AXIS : StringName = "horizontalAxis"
const VERTICAL_AXIS : StringName = "verticalAxis"

func _init():
	properties[FOLLOW_OFFSET] = Vector3.ZERO
	properties[RADIUS] = 0.0

	properties[HORIZONTAL_AXIS] = 0.0
	properties[VERTICAL_AXIS] = 0.0

func build_properties(component : TrackingComponent) -> Array:
	var property_list: Array[Dictionary]
	
	var isFollow = component.positionControl == TypeCameras.PositionControl.FOLLOW
	var isOrbital = component.positionControl == TypeCameras.PositionControl.ORBITAL_FOLLOW
	
	if  isFollow:
		property_list.append({
			"name": "Follow",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_GROUP
		})
		
		property_list.append({
			"name": FOLLOW_OFFSET,
			"type": TYPE_VECTOR3,
		})
	
	if isOrbital:
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
			"name": RADIUS,
			"type": TYPE_FLOAT,
		})
		property_list.append({
			"name": HORIZONTAL_AXIS,
			"type": TYPE_FLOAT
		})
		property_list.append({
			"name": VERTICAL_AXIS,
			"type": TYPE_FLOAT
		})
	return property_list
