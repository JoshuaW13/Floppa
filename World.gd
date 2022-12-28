extends Node


#Fields
var points=0;
onready var scoreBoard = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreBoard.text = str(points)

func _on_PreySpawner_pointScored(to_add) -> void:
	points += to_add
	scoreBoard.text = str(points)
