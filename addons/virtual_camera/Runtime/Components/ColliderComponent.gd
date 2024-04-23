@tool
class_name ColliderComponent extends VirtualCameraBaseComponent

@export_category("Obstacle Detection")
@export var strategy : TypeCameras.ObstacleDetectionStrategy = TypeCameras.ObstacleDetectionStrategy.NONE:
	get:
		return strategy
	set(value):
		strategy = value
		set_physics_process(strategy == TypeCameras.ObstacleDetectionStrategy.PULL_CAMERA_FORWARD)

@export_flags_3d_physics var collision_flags 

@export var margin : float

var radius_collider : float = 0
var triggered : bool = false
	
func after_ready():
	_parent.collider = self

func _physics_process(delta):
	if not _parent.is_active_camera():
		return

	var space_state = _parent.get_world_3d().direct_space_state	
	var target = _parent.basis.y * _parent.tracking.get_radius()
	var position = _parent.global_position
	
	var query = PhysicsRayQueryParameters3D.create(position, position + target, collision_flags)
	var result = space_state.intersect_ray(query)	
	if result:		
		var collider_position = result.position + (result.normal * margin)		
		radius_collider = collider_position.distance_to(position)
		triggered = true
	else:
		triggered = false
	
	print(triggered, " ", radius_collider)
