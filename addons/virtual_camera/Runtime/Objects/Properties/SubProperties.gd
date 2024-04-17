class_name SubProperties

var properties : Dictionary = {}

func build_properties(component : TrackingComponent) -> Array:
	var property_list: Array[Dictionary]
	
	return property_list

func set_property_value(property: StringName, value) -> bool:
	if not properties.has(property):
		return false
	
	properties[property] = value
	return true

func get_property_value(property: StringName):
	if properties.has(property):
		return properties[property]

func increment_property_value(property: StringName, incrementValue) -> bool:
	var oldValue = get_property_value(property)
	return set_property_value(property, oldValue + incrementValue)
