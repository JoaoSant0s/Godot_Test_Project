@tool
class_name VirtualCamera extends Node3D

var _isEditorMode = Engine.is_editor_hint()

@export var enabled: bool = true:
	get:
		return enabled
	set(value):
		if enabled == value: return
		enabled = value
		if _isEditorMode: return
		VirtualCameraService.onEnabledModified.emit(self)

@export var priority: int = 0:
	get:
		return priority
	set(value):
		if priority == value: return
		priority = value
		if _isEditorMode: return
		VirtualCameraService.onPriorityModified.emit(self)

@export var trackingTarget : Node3D
@export var lookAt : Node3D

@export var processMethod: UtilsCamera.UpdateMethods = UtilsCamera.UpdateMethods.DEFAULT_PROCESS:
	get:
		return processMethod
	set(value):
		processMethod = value

@export var lens : LensComponent

func _enter_tree():
	if _isEditorMode: return
	VirtualCameraService.addVirtualCamera(self)

func _ready():
	if not _isEditorMode: return
	UtilsCamera.createLensComponent(self)	
	
func _exit_tree():
	if _isEditorMode: return
	VirtualCameraService.removeVirtualCamera(self)

func _to_string():
	return "<-> {%n}: {%p} - {%s} <->".format({"%n" : name, "%p" : priority, "%s": enabled})
