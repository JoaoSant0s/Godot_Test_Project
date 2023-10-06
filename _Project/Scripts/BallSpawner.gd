extends Node2D

var ballPrefab = preload("res://_Project/Prefabs/ball.tscn")

@export var delayInSeconds : float
@export var possiblePositions : Array[Node2D]

func _ready():
	UiSignals.onTestSignal.connect(testInstantiateBall)
	instantiateBallsRountie()

func instantiateBallsRountie():
	while true:		
		await get_tree().create_timer(delayInSeconds).timeout
		instantiateBall()

func instantiateBall():
	var instance = ballPrefab.instantiate()
	var rand_index:int = randi() % possiblePositions.size()

	instance.position = possiblePositions[rand_index].position
	add_child(instance)	
	
func testInstantiateBall(previousValue : int, newValue : int):
	print(previousValue," <-> ", newValue);
	instantiateBall()
