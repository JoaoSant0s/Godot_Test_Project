@tool
class_name ColliderComponent extends VirtualCameraBaseComponent

var _is_editor_mode = Engine.is_editor_hint()

const TRANSITION_SPEED : StringName  = "transition_speed"

@export_category("Obstacle Detection")
@export_group("General Config")
@export var strategy : TypeCameras.ObstacleDetectionStrategy = TypeCameras.ObstacleDetectionStrategy.NONE:
	get:
		return strategy
	set(value):
		strategy = value
		set_physics_process(strategy == TypeCameras.ObstacleDetectionStrategy.PULL_CAMERA_FORWARD)
		notify_property_list_changed()

@export_flags_3d_physics var collision_flags:
	get:
		return collision_flags
	set(value):
		collision_flags = value
		if raycast:
			raycast.collision_mask = collision_flags

@export var raycast : RayCast3D

@export var normal_margin : float = 1

@export_group("Pull Camera Forward")
@export var transition_enabled : bool = true:
	get:
		return transition_enabled
	set(value):
		transition_enabled = value
		notify_property_list_changed()
		
@export var transition_speed : float = 10:
	get:
		return transition_speed
	set(value):
		transition_speed = value

var radius_collider : float = 0
var triggered : bool = false

var frame_collision_error_margin : int = 2
var triggered_previously : bool = false
var frame_counter : int = 0

func after_ready():
	_parent.collider = self
	if not _is_editor_mode: return
	UtilsCamera.prepare_collider_component(self)
	raycast.collision_mask = collision_flags

func _validate_property(property: Dictionary):
	if property.name == TRANSITION_SPEED and not transition_enabled:
		property.usage = PROPERTY_USAGE_NONE

func _physics_process(delta):
	if not _parent.is_active_camera():
		return

	raycast.global_position = _parent.tracking.look_at.global_position
	raycast.target_position = (_parent.global_position - raycast.global_position).normalized() * _parent.tracking.radius
	
	var triggered_now = raycast.is_colliding()

	if triggered_now:
		var collider_position = raycast.get_collision_point() + (raycast.get_collision_normal() * normal_margin)
		var nextRadiusCollider = collider_position.distance_to(raycast.global_position)
		
		if transition_enabled:
			radius_collider = lerp(radius_collider, nextRadiusCollider, delta * transition_speed)
		else:
			radius_collider = nextRadiusCollider
		
		triggered_previously = true
		frame_counter = 0
	else:
		triggered_now = check_collision_error_margin()
	
	triggered = triggered_now

func check_collision_error_margin() -> bool:
	if triggered_previously and frame_counter < frame_collision_error_margin:
		frame_counter += 1
		return true

	triggered_previously = false
	frame_counter = 0
	return false
