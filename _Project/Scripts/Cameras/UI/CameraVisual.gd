class_name CameraVisual extends Control

@onready var texture_rect = $TextureRect
@onready var label = $Label

@export var platformTriggers : Array[PlatformTrigger]
# Called when the node enters the scene tree for the first time.
func _ready():
	var mainCamera = VirtualCameraService.get_main_camera()
	var selectedPlatform = null
	
	if mainCamera != null:
		for platform in platformTriggers:
			if mainCamera.is_current_camera(platform.virtualCamera):
				selectedPlatform = platform
				break
	
	_set_camera_visual_by_platform(selectedPlatform)
	
	VirtualCameraService.on_virtual_camera_modified.connect(_virtual_camera_modified)

func _virtual_camera_modified(camera : VirtualCamera):
	var selectedPlatform = null
	
	for platform in platformTriggers:
		if platform.virtualCamera == camera:
			selectedPlatform = platform
			break
	
	_set_camera_visual_by_platform(selectedPlatform)

func _set_camera_visual_by_platform(selectedPlatform : PlatformTrigger):
	if selectedPlatform == null:
		_set_camera_visual(null, "")
	else:
		_set_camera_visual(selectedPlatform.icon, selectedPlatform.cameraName)

func _set_camera_visual(icon : Texture2D, cameraName : String):
	texture_rect.texture = icon
	label.text = cameraName
