class_name UtilsCamera

enum ProcessMethods {DEFAULT_PROCESS, PHYSICS_PROCESS, DISABLED}

static func createLensComponent(virtualCamera : VirtualCamera):
	var hasComponent = virtualCamera.get_children().any(func (node): return node is LensComponent);
	if hasComponent: return
			
	var instance = _createComponent("LensComponent", "res://addons/virtualcameraplugin/VirtualCamera/Prefabs/LensComponent.tscn", virtualCamera) as LensComponent
	virtualCamera.lens = instance;
	instance.set_owner(virtualCamera.get_tree().edited_scene_root)

static func createTrackingComponent(virtualCamera : VirtualCamera):
	var hasComponent = virtualCamera.get_children().any(func (node): return node is TrackingComponent);
	if hasComponent: return

	var instance = _createComponent("TrackingComponent", "res://addons/virtualcameraplugin/VirtualCamera/Prefabs/TrackingComponent.tscn", virtualCamera) as TrackingComponent
	virtualCamera.tracking = instance;
	instance.set_owner(virtualCamera.get_tree().edited_scene_root)

static func _createComponent(name : String, path : String, parent):
	var instance = load(path).instantiate()
	instance.name = name
	parent.add_child(instance);
	instance.set_owner(parent.get_tree().edited_scene_root)
	return instance


static func print(message : String):
	if(VirtualCameraConfig.Instance.showLogs): print(message)
