class_name UtilsCamera

enum UpdateMethods {PROCESS, PHYSICS_PROCESS, DISABLED}

enum VirtualCameraStatus {RUNNING, WAITING, DISABLED}

static func rotated(baseVector : Vector3, angle: Vector3):
	baseVector = baseVector.rotated(Vector3.RIGHT, angle.x)
	baseVector = baseVector.rotated(Vector3.UP, angle.y)
	baseVector = baseVector.rotated(Vector3.BACK, angle.z)
	return baseVector
