class_name MathCameras

static func bi_angle_to_directional_position(tetaAngle : float, phiAngle : float) -> Vector3:
	var cosPhi =  cos(deg_to_rad(phiAngle))

	var x = cosPhi * sin(deg_to_rad(tetaAngle))
	var y = sin(deg_to_rad(phiAngle))
	var z = cosPhi * cos(deg_to_rad(tetaAngle))

	return Vector3(x, y, z)


static func normilized_direction_to_decomposed_axis_angle(directionalPosition : Vector3):
	var angle_axis : Vector3
	
	var x = directionalPosition.x
	var y = directionalPosition.y
	var z = directionalPosition.z
	
	var powX = x * x
	var powY = y * y
	var powZ = z * z
	
	angle_axis.x = atan2(sqrt(powY + powZ), x)
	angle_axis.y = atan2(sqrt(powX + powZ), y)
	angle_axis.z = atan2(sqrt(powX + powY), z)
	
	return angle_axis
