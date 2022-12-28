extends Node

export var mainGameScene: PackedScene

func _on_PlayButton_button_up() -> void:
	get_tree().change_scene(mainGameScene.resource_path)

#quite the game
func _on_TextureButton_button_up() -> void:
	get_tree().quit()
