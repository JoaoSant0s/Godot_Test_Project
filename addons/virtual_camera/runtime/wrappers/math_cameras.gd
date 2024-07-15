class_name MathCameras

static var half_PI = PI/2

static func bi_angle_to_directional_position(teta_angle : float, phi_angle : float) -> Vector3:
	var cos_phi =  cos(deg_to_rad(phi_angle))

	var x = cos_phi * sin(deg_to_rad(teta_angle))
	var y = sin(deg_to_rad(phi_angle))
	var z = cos_phi * cos(deg_to_rad(teta_angle))

	return Vector3(x, y, z)

static func normilized_direction_to_decomposed_axis_angle(directional_position : Vector3) -> Vector3:
	var angle_axis : Vector3

	angle_axis.x = asin(directional_position.y)
	angle_axis.y = atan2(directional_position.x, directional_position.z) + PI

	return angle_axis
