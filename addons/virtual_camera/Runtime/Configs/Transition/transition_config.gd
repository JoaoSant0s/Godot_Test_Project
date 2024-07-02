@tool
class_name TransitionConfig extends Resource

@export var default_transition_method : TransitionMethodConfig
@export var transition_blend_config : Array[TransitionBlendConfig]

func get_matched_transition_method(pCamera: VirtualCamera, nCamera : VirtualCamera) -> TransitionMethodConfig:
	var result : TransitionMethodConfig = null
	var any_camera_id = VirtualCameraConfig.Instance.any_camera_id
	
	for blendConfig in transition_blend_config:
		var from_matched = pCamera != null and (blendConfig.from == any_camera_id or blendConfig.from == pCamera.tag or blendConfig.from == pCamera.group)
		var to_matched = nCamera != null and (blendConfig.to == any_camera_id or blendConfig.to == nCamera.tag or blendConfig.to == nCamera.group)

		if from_matched and to_matched:
			result = blendConfig.transition_method
			break

	if result == null:
		result = default_transition_method

	return result
