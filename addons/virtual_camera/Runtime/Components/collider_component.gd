@tool
class_name ColliderComponent extends VirtualCameraBaseComponent

var _is_editor_mode = Engine.is_editor_hint()

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

var collider_sub_properties : ColliderSubProperties
var radius_collider : float = 0
var triggered : bool = false

var frame_collision_error_margin : int = 2
var triggered_previously : bool = false
var frame_counter : int = 0

func _init():
	collider_sub_properties = ColliderSubProperties.new()
	
func after_ready():
	_parent.collider = self
	if not _is_editor_mode: return
	UtilsCamera.prepare_collider_component(self)
	raycast.collision_mask = collision_flags

func _physics_process(delta):
	if not _parent.is_active_camera():
		return

	raycast.global_position = _parent.tracking.look_at.global_position
	raycast.target_position = (_parent.global_position - raycast.global_position).normalized() * _parent.tracking.get_radius()
	
	var triggered_now = raycast.is_colliding()

	if triggered_now:
		var collider_position = raycast.get_collision_point() + (raycast.get_collision_normal() * normal_margin)
		var nextRadiusCollider = collider_position.distance_to(raycast.global_position)
		
		if collider_sub_properties.transition_enabled:
			radius_collider = lerp(radius_collider, nextRadiusCollider, delta * collider_sub_properties.transition_speed)
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

func _get_property_list() -> Array:
	var property_list: Array[Dictionary]
	
	property_list.append_array(collider_sub_properties.build_properties(self))
	
	return property_list

func _set(property: StringName, value) -> bool:
	var result = collider_sub_properties.set_property_value(property, value)
	if result:
		notify_property_list_changed()
	
	return result
	
func _get(property):
	return collider_sub_properties.get_property_value(property)
