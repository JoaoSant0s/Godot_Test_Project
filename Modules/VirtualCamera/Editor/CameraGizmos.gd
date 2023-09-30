@tool
extends Node

@export var showGizmos: bool = true:
	get:
		return showGizmos
	set(value):
		showGizmos = value
		if value and Engine.is_editor_hint():
			_tryCreateLine()
			set_process(true)
		else:
			set_process(false)
			destroyLine()
			pass
		print("teste ", value)

var directionalLine : MeshInstance3D = null
var parent : Node3D = null

func _tryCreateLine():
	if directionalLine != null: return
	
	directionalLine = createLine(Vector3.ZERO, Vector3.FORWARD * 10)
	
func destroyLine():
	var line = directionalLine
	directionalLine = null
	
	if line != null:
		line.queue_free()	
		
func _exit_tree():
	print("_exit_tree ", directionalLine)
	destroyLine()

func _ready():
	parent = get_parent()
	if showGizmos:
		_tryCreateLine()

func _process(delta):
	directionalLine.global_position = parent.global_position
	directionalLine.rotation = parent.rotation

func createLine(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()	
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	parent.add_child(mesh_instance)
	
	return mesh_instance
