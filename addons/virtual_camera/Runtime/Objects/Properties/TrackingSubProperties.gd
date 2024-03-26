class_name TrackingSubProperties extends SubProperties

const FOLLOWOFFSET : StringName  = "followOffset"

func _init():
	properties[FOLLOWOFFSET] = Vector3.ZERO

func build_properties(component : TrackingComponent) -> Array:
	var property_list: Array[Dictionary]
	
	if component.positionControl == TypeCameras.PositionControl.FOLLOW:
		property_list.append({
			"name": FOLLOWOFFSET,
			"type": TYPE_VECTOR3,
		})
	
	return property_list
