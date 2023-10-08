class_name UtilsCamera

static func createLensComponent(camera : VirtualCamera):
	var hasComponent = camera.get_children().any(func (node): return node is LensComponent);
	if hasComponent: return
			
	var instance = _createComponent("LensComponent", "res://addons/virtualcameraplugin/VirtualCamera/Prefabs/LensComponent.tscn", camera) as LensComponent
	camera.lens = instance;
	instance.set_owner(camera.get_tree().edited_scene_root)

static func createTrackingComponent(camera : VirtualCamera):
	var hasComponent = camera.get_children().any(func (node): return node is TrackingComponent);
	if hasComponent: return

	var instance = _createComponent("TrackingComponent", "res://addons/virtualcameraplugin/VirtualCamera/Prefabs/TrackingComponent.tscn", camera) as TrackingComponent
	camera.tracking = instance;
	instance.set_owner(camera.get_tree().edited_scene_root)

static func _createComponent(name : String, path : String, parent):
	var instance = load(path).instantiate()
	instance.name = name
	parent.add_child(instance);
	instance.set_owner(parent.get_tree().edited_scene_root)
	return instance


static func print(message):
	if(not VirtualCameraConfig.Instance.showLogs): return
	var _isEditorMode = Engine.is_editor_hint()

	if _isEditorMode:
		print("Virtual Camera Editor: ", message)
	else:
		print("Virtual Camera Play Mode ", message)
