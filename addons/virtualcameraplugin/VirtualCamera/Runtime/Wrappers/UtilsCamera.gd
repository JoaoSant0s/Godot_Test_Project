class_name UtilsCamera

enum UpdateMethods {DEFAULT_PROCESS, PHYSICS_PROCESS, DISABLED}	

static func createLensComponent(virtualCamera : VirtualCamera):
	var hasLens = virtualCamera.get_children().any(func (node): return node is LensComponent);
	if hasLens: return
			
	var lensInstance = _createComponent("LensComponent", "res://addons/virtualcameraplugin/VirtualCamera/Prefabs/LensComponent.tscn", virtualCamera) as LensComponent
	virtualCamera.lens = lensInstance;
	lensInstance.set_owner(virtualCamera.get_tree().edited_scene_root)


static func _createComponent(name : String, path : String, parent):
	var lensInstance = load(path).instantiate()
	lensInstance.name = name
	parent.add_child(lensInstance);
	lensInstance.set_owner(parent.get_tree().edited_scene_root)
	return lensInstance
