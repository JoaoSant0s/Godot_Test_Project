class_name UtilsCamera

const VIRTUAL_CAMERA_TAG = "[Virtual_Camera] "
const EDITOR_TAG = "[Editor] "
const PLAY_MODE_TAG = "[Play_Mode] "

static func prepare_collider_component(collider_component : ColliderComponent):
	var components = collider_component.get_children().filter(func (node): return node is RayCast3D)

	if components.size() > 0:
		collider_component.raycast = components[0] as RayCast3D
		return
	
	var instance = RayCast3D.new()
	instance.name = "RayCast3D"
	collider_component.raycast = instance;
	collider_component.add_child(instance);
	instance.set_owner(collider_component.get_tree().edited_scene_root)

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
	if(not VirtualCameraConfig.Instance.show_logs): return
	var _is_editor_mode = Engine.is_editor_hint()

	if _is_editor_mode:
		print(VIRTUAL_CAMERA_TAG, EDITOR_TAG, message)
	else:
		print(VIRTUAL_CAMERA_TAG, PLAY_MODE_TAG, message)
