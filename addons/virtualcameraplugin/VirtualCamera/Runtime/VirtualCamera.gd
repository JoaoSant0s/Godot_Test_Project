@tool
class_name VirtualCamera extends Node3D

var _isEditorMode = Engine.is_editor_hint()

@export_group("Properties")
@export var enabled: bool = true:
	get:
		return enabled
	set(value):
		if enabled == value: return
		enabled = value
		VirtualCameraService.onEnabledModified.emit(self)

@export var priority: int = 0:
	get:
		return priority
	set(value):
		if priority == value: return
		priority = value
		VirtualCameraService.onPriorityModified.emit(self)

@export var processMethod: TypeCameras.ProcessMethods = TypeCameras.ProcessMethods.DEFAULT_PROCESS:
	get:
		return processMethod
	set(value):
		processMethod = value
		
@export_group("Assets")

@export var tag: CameraTagAsset:
	get:
		return tag
	set(value):
		tag = value
		if null == value: return
		if not VirtualCameraService.isTagUnique(self):
			tag = null;

@export var group : CameraGroupAsset

@export_group("Components")
@export var lens : LensComponent

@export var tracking : TrackingComponent

func isActiveCamera() -> bool:
	return VirtualCameraService.isCurrentCamera(self)

func forceActiveCamera():
	if isActiveCamera(): return;

	VirtualCameraService.forceActive(self)
	
func _enter_tree():
	VirtualCameraService.addVirtualCamera(self)

func _ready():
	if not _isEditorMode: return
	UtilsCamera.createLensComponent(self)
	UtilsCamera.createTrackingComponent(self)
	
func _exit_tree():
	VirtualCameraService.removeVirtualCamera(self)

func _to_string():
	return "%s" % name

func _get_configuration_warnings():
	var warnings = []
	if lens == null:
		warnings.append("The LensComponent is created automatically when a VirtualCamera is added on the scene on Editor Mode")
	elif tracking == null:
		warnings.append("The TrackingComponent is created automatically when a VirtualCamera is added on the scene on Editor Mode")
			
	return warnings
