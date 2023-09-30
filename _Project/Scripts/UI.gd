extends Node

@export var tapButton : Button


var testValue = 0;
func _ready():
	tapButton.pressed.connect(self._button_pressed)	

func _button_pressed():
	var previousValue = testValue;
	testValue += 1;
	UiSignals.onTestSignal.emit(previousValue, testValue)
