extends Resource

class_name BootConfig

@export var usingMainScene : bool

@export_file("*.tscn") var scene2DPath
@export_file("*.tscn") var scene3DPath

static var instance : BootConfig

static var Instance: BootConfig:
	get:
		if instance == null:
			instance = ResourceLoader.load("res://_Project/Config/Core/BootConfig.tres") as BootConfig
		
		return instance	

func nextScene():
	return scene2DPath if usingMainScene else scene3DPath

