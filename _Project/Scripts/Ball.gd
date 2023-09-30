extends Node2D

@export var destroyAfterSeconds : float
func _ready():
	UiSignals.onTestSignal.connect(testInstantiateBall)
	await get_tree().create_timer(destroyAfterSeconds).timeout
	
	if is_instance_valid(self):
		queue_free()


func _exit_tree():
	UiSignals.onTestSignal.disconnect(testInstantiateBall)
	print("Exit")

func testInstantiateBall(previousValue : int, newValue : int):
	print(previousValue," <-> ", newValue);	
