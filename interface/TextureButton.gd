extends TextureButton

onready var toolTipButton = $ColorRect/Label
onready var colorRect = $ColorRect
export var unlocked = true;

func _ready() -> void:
	colorRect.hide()
	toolTipButton.text = "HELLOOOOOOO"

func _on_TextureButton_mouse_entered() -> void:
	if !unlocked:
		colorRect.show()


func _on_TextureButton_mouse_exited() -> void:
	colorRect.hide()


func _on_TextureButton_button_down() -> void:
	colorRect.hide()
