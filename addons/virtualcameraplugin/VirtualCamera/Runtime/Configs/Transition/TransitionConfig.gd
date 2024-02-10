class_name TransitionConfig extends Resource

@export var defaultTransitionMethod : TransitionMethodConfig
@export var transitionBlendConfig : Array[TransitionBlendConfig]


func getMatchedTransitionMethod(pCamera: VirtualCamera, nCamera : VirtualCamera) -> TransitionMethodConfig:
	var result : TransitionMethodConfig = null
	var anyCameraId = VirtualCameraConfig.Instance.anyCameraId
	
	for blendConfig in transitionBlendConfig:			
		var fromMatched = pCamera != null and (blendConfig.from == anyCameraId or blendConfig.from == pCamera.tag or blendConfig.from == pCamera.group)
		var toMatched = nCamera != null and (blendConfig.to == anyCameraId or blendConfig.to == nCamera.tag or blendConfig.to == nCamera.group)

		if fromMatched and toMatched:
			result = blendConfig.transitionMethod
			break

	if result == null:
		result = defaultTransitionMethod

	return result
