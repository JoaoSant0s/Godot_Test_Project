@tool
class_name ColliderComponent extends VirtualCameraBaseComponent

var _isEditorMode = Engine.is_editor_hint()

@export_category("Obstacle Detection")
@export var strategy : TypeCameras.ObstacleDetectionStrategy = TypeCameras.ObstacleDetectionStrategy.NONE:
	get:
		return strategy
	set(value):
		strategy = value
		set_physics_process(strategy == TypeCameras.ObstacleDetectionStrategy.PULL_CAMERA_FORWARD)

@export_flags_3d_physics var collision_flags:
	get:
		return collision_flags
	set(value):
		collision_flags = value
		if raycast:
			raycast.collision_mask = collision_flags

@export var raycast : RayCast3D

@export var normalMargin : float = 1

var radiusCollider : float = 0
var triggered : bool = false

var frameCollisionErrorMargin : int = 2
var triggeredPreviously : bool = false
var frameCounter : int = 0

func after_ready():
	_parent.collider = self
	if not _isEditorMode: return
	UtilsCamera.prepare_collider_component(self)
	raycast.collision_mask = collision_flags

func _physics_process(delta):
	if not _parent.is_active_camera():
		return

	raycast.global_position = _parent.tracking.lookAt.global_position
	raycast.target_position = (_parent.global_position - raycast.global_position).normalized() * _parent.tracking.get_radius()
	
	var triggeredNow = raycast.is_colliding()

	if triggeredNow:
		var collider_position = raycast.get_collision_point() + (raycast.get_collision_normal() * normalMargin)
		radiusCollider = collider_position.distance_to(raycast.global_position)
		triggeredPreviously = true
		frameCounter = 0
	else:
		triggeredNow = check_collision_error_margin()
	
	triggered = triggeredNow

func check_collision_error_margin() -> bool:
	if triggeredPreviously and frameCounter < frameCollisionErrorMargin:
		frameCounter += 1
		return true

	triggeredPreviously = false
	frameCounter = 0
	return false
