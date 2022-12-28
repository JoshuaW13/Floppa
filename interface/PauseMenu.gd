extends CanvasLayer

#variables
onready var pauseItems = $Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#detects escape key press
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		pass

#toggles pause status
func toggle_pause():
	get_tree().paused = !get_tree().paused
	for node in pauseItems.get_children():
		node.visible = !node.visible


#exit pause when x pressed
func _on_XButton_button_up() -> void:
	toggle_pause()

#pause button 
func _on_pausebutton_button_up() -> void:
	toggle_pause()


func _on_homebutton_button_up() -> void:
	toggle_pause()
	get_tree().change_scene("res://interface/TitleScreen.tscn")


func _on_restartbutton_button_up() -> void:
	toggle_pause()
	get_tree().change_scene("res://World.tscn")
