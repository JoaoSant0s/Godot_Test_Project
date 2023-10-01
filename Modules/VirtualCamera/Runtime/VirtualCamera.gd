class_name VirtualCamera extends Node3D

@export var enabled: bool = true:
	get:
		return enabled
	set(value):
		if enabled == value: return
		enabled = value
		VirtualCameraService.onEnabledModified.emit(self)
		print(name, " ", "enabled ",enabled)

@export var priority: int = 0:
	get:
		return priority
	set(value):
		if priority == value: return
		priority = value
		VirtualCameraService.onPriorityModified.emit(self)
		print(name, " ", "priority ",value)
		
@export var follow : Node3D

@export var lookAt : Node3D

@export var processMethod: UtilsCamera.UpdateMethods = UtilsCamera.UpdateMethods.DEFAULT_PROCESS:
	get:
		return processMethod
	set(value):
		processMethod = value
		print(name, " ", "processMethod ",value)
	
func _enter_tree():
	VirtualCameraService.addVirtualCamera(self)

func _exit_tree():
	VirtualCameraService.removeVirtualCamera(self)

func _to_string():
	return "<-> {%n}: {%p} - {%s} <->".format({"%n" : name, "%p" : priority, "%s": enabled})
