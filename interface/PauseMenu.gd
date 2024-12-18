extends CanvasLayer

#variables
onready var pauseItems = $Control
var gameover = false;
var killedEnnemies =0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#make sure scene always starts playing
	get_tree().paused = false

#detects escape key press
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if !gameover:
			toggle_pause()

#toggles pause status
func toggle_pause():
	get_tree().paused = !get_tree().paused
	for node in pauseItems.get_children():
		node.visible = !node.visible

func player_died_menu(score):
	gameover = true;
	var pauseButton = $Control/pausebutton
	var score_display = $Control/PauseMenu/Score
	var high_score_display = $Control/PauseMenu/HighScore
	PlayerData.check_highscore(score)
	PlayerData.check_Killed_Ennemies(killedEnnemies);
	high_score_display.text = "HighScore: "+str(PlayerData.highScore)
	score_display.text = "Score: "+str(score)
	for node in pauseItems.get_children():
		node.visible = !node.visible
		if node.name == "PauseMenu":
			node.get_node("XButton").visible = false
	score_display.visible=true
	high_score_display.visible=true;
	pauseButton.visible = false


#exit pause when x pressed
func _on_XButton_button_up() -> void:
	AudioController.buttonClick()
	toggle_pause()

#pause button 
func _on_pausebutton_button_up() -> void:
	AudioController.buttonClick()	
	toggle_pause()

func _on_homebutton_button_up() -> void:
	AudioController.buttonClick()
	toggle_pause()
	var _sceneChangeStatus = get_tree().change_scene("res://interface/TitleScreen.tscn")


func _on_restartbutton_button_up() -> void:
	AudioController.buttonSelection()
	toggle_pause()
	var _sceneChangeStatus = get_tree().change_scene("res://World.tscn")


func _on_EnnemySpawner_ennemyKilled() -> void:
	killedEnnemies += 1;
