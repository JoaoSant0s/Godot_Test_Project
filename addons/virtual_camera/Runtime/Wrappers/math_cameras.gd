class_name MathCameras

static var half_PI = PI/2

static func bi_angle_to_directional_position(tetaAngle : float, phiAngle : float) -> Vector3:
	var cosPhi =  cos(deg_to_rad(phiAngle))

	var x = cosPhi * sin(deg_to_rad(tetaAngle))
	var y = sin(deg_to_rad(phiAngle))
	var z = cosPhi * cos(deg_to_rad(tetaAngle))

	return Vector3(x, y, z)

static func normilized_direction_to_decomposed_axis_angle(directionalPosition : Vector3) -> Vector3:
	var angle_axis : Vector3

	angle_axis.x = asin(directionalPosition.y)
	angle_axis.y = atan2(directionalPosition.x, directionalPosition.z) + PI

	return angle_axis
