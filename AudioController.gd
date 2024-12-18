extends Node

onready var buttonClick = $buttonClick
onready var buttonSelection = $buttonSelection

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS;

func buttonClick():
	buttonClick.play()

func buttonSelection():
	buttonSelection.play(0.15)
