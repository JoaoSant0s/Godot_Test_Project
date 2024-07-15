class_name VirtualCameraConfig extends Resource

@export var show_logs : bool = true
@export var debug_visualization : bool
@export var any_camera_id : CameraIdAsset

static var _instance : VirtualCameraConfig

static var Instance: VirtualCameraConfig:
	get:
		if _instance == null:
			_instance = ResourceLoader.load("res://Resources/Config/VirtualCameraConfig.tres") as VirtualCameraConfig
			assert(_instance != null and _instance is VirtualCameraConfig, "Must create a VirtualCameraConfig on the path res://Resources/Config/VirtualCameraConfig.tres")

		return _instance
