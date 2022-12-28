extends CanvasLayer

signal exit;


func _on_XButton_button_up() -> void:
	emit_signal("exit")
