class_name UtilsCamera

enum UpdateMethods {DEFAULT_PROCESS, PHYSICS_PROCESS, DISABLED}

static func createLensComponent(virtualCamera : VirtualCamera):
	var hasLens = virtualCamera.get_children().any(func (node): return node is LensComponent);
	if hasLens: return
		
	var lensInstance = load("res://Modules/VirtualCamera/Prefabs/LensComponent.tscn").instantiate()
	lensInstance.name = "LensComponent"
	virtualCamera.add_child(lensInstance);
	lensInstance.set_owner(virtualCamera.get_tree().edited_scene_root)
	virtualCamera.lens = lensInstance;	
