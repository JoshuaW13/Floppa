extends Node


#Fields
var points=0;
onready var scoreBoard = $Label
onready var pauseMenu = $PauseMenu
onready var player = $PLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreBoard.text = str(points)

func _on_PreySpawner_pointScored(to_add) -> void:
	points += to_add
	scoreBoard.text = str(points)

func _on_PLayer_killed() -> void:
	player.queue_free()
	pauseMenu.player_died_menu()

func _on_EnnemySpawner_pointScored(to_add) -> void:
	points += to_add
	scoreBoard.text = str(points)
