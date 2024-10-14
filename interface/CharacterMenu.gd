extends CanvasLayer

signal exit;


func _on_XButton_button_up() -> void:
	emit_signal("exit")


func _on_CharacterInfo_characterSelected() -> void:
	emit_signal("exit")
