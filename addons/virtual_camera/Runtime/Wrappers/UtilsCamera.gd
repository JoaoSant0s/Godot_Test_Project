class_name UtilsCamera

const virtualCameraTag = "[Virtual_Camera] "
const editorTag = "[Editor] "
const playModeTag = "[Play_Mode] "

static func create_lens_component(camera : VirtualCamera):	
	var components = camera.get_children().filter(func (node): return node is LensComponent)

	if components.size() > 0:
		camera.lens = components[0] as LensComponent
		return
	
	var instance = LensComponent.new()
	instance.name = "LensComponent"
	camera.lens = instance;	
	camera.add_child(instance);
	instance.set_owner(camera.get_tree().edited_scene_root)

static func create_tracking_component(camera : VirtualCamera):
	var components = camera.get_children().filter(func (node): return node is TrackingComponent)	
	
	if components.size() > 0:
		camera.tracking = components[0] as TrackingComponent
		return

	var instance = TrackingComponent.new()
	instance.name = "TrackingComponent"
	camera.tracking = instance;
	camera.add_child(instance);
	instance.set_owner(camera.get_tree().edited_scene_root)

static func _create_component(name : String, path : String, parent):
	var instance = load(path).instantiate()
	instance.name = name
	parent.add_child(instance);
	instance.set_owner(parent.get_tree().edited_scene_root)
	return instance

static func extract_resource_name(resource : Resource):
	return resource.resource_path.get_file().trim_suffix(".tres")
	
static func log(message):
	if(not VirtualCameraConfig.Instance.showLogs): return
	var _isEditorMode = Engine.is_editor_hint()

	if _isEditorMode:
		print(virtualCameraTag, editorTag, message)
	else:
		print(virtualCameraTag, playModeTag, message)
