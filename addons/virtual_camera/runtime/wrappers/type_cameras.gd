class_name TypeCameras extends Node

enum ProcessMethods {DEFAULT_PROCESS, PHYSICS_PROCESS, DISABLED}

enum TransitionMethods {CUT, LINEAR}

enum PositionControl {NONE, HARD_LOCK_TO_TARGET, FOLLOW, ORBITAL_FOLLOW, PATH_FOLLOW }

enum RotationControl {NONE, HARD_LOOK_AT, SAME_AS_FOLLOW_TARGET}

enum ObstacleDetectionStrategy {NONE, PULL_CAMERA_FORWARD}
