extends CanvasLayer

signal exit;


func _on_XButton_button_up() -> void:
	print("exit emmited!")
	emit_signal("exit")
