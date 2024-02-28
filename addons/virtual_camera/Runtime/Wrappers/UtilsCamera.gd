class_name UtilsCamera

const virtualCameraTag = "[Virtual_Camera] "
const editorTag = "[Editor] "
const playModeTag = "[Play_Mode] "

static func createLensComponent(camera : VirtualCamera):
	var hasComponent = camera.get_children().any(func (node): return node is LensComponent);
	if hasComponent:
		camera.lens = camera.get_node("LensComponent") as LensComponent
		return

	var instance = _createComponent("LensComponent", "res://addons/virtual_camera/LensComponent.tscn", camera) as LensComponent
	camera.lens = instance;
	instance.set_owner(camera.get_tree().edited_scene_root)

static func createTrackingComponent(camera : VirtualCamera):
	var hasComponent = camera.get_children().any(func (node): return node is TrackingComponent);
	if hasComponent: 
		camera.tracking = camera.get_node("TrackingComponent") as TrackingComponent
		return

	var instance = _createComponent("TrackingComponent", "res://addons/virtual_camera/TrackingComponent.tscn", camera) as TrackingComponent
	camera.tracking = instance;
	instance.set_owner(camera.get_tree().edited_scene_root)

static func _createComponent(name : String, path : String, parent):
	var instance = load(path).instantiate()
	instance.name = name
	parent.add_child(instance);
	instance.set_owner(parent.get_tree().edited_scene_root)
	return instance

static func extractResourceName(resource : Resource):
	return resource.resource_path.get_file().trim_suffix(".tres")
	
static func log(message):
	if(not VirtualCameraConfig.Instance.showLogs): return
	var _isEditorMode = Engine.is_editor_hint()

	if _isEditorMode:
		print(virtualCameraTag, editorTag, message)
	else:
		print(virtualCameraTag, playModeTag, message)