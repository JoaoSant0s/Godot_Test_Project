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

@export var raycast : RayCast3D

@export var margin : float

var radius_collider : float = 0
var triggered : bool = false
	
func after_ready():
	_parent.collider = self

func _process(delta):	
	if not _parent.is_active_camera():
		return

	raycast.global_position = _parent.tracking.lookAt.global_position
	raycast.target_position = _parent.global_position - raycast.global_position	
	
	if raycast.is_colliding():
		var collider_position = raycast.get_collision_point() + (raycast.get_collision_normal() * margin)
		radius_collider = collider_position.distance_to(raycast.global_position)
		
	triggered = raycast.is_colliding()
