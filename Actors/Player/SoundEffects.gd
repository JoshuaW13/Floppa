extends Node


signal soundFinished;


func _on_Damage_finished() -> void:
	emit_signal("soundFinished")


func _on_Eaten_finished() -> void:
	emit_signal("soundFinished")
