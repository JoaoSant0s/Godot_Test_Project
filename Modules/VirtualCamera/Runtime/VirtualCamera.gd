class_name VirtualCamera extends Node3D

@export var status: UtilsCamera.VirtualCameraStatus = UtilsCamera.VirtualCameraStatus.RUNNING:
	get:
		return status
	set(value):
		status = value
		print(name, " ", "status ",status)

@export var follow : Node3D
@export var lookAt : Node3D

@export var processMethod: UtilsCamera.UpdateMethods = UtilsCamera.UpdateMethods.PROCESS:
	get:
		return processMethod
	set(value):
		processMethod = value
		print(name, " ", "processMethod ",value)


func isStatusRunning():
	return status == UtilsCamera.VirtualCameraStatus.RUNNING

func isStatusWaiting():
	return status == UtilsCamera.VirtualCameraStatus.WAITING

func isStatusDisabled():
	return status == UtilsCamera.VirtualCameraStatus.DISABLED
	
func _enter_tree():
	VirtualCameraService.addVirtualCamera(self)	

func _exit_tree():
	VirtualCameraService.removeVirtualCamera(self)
