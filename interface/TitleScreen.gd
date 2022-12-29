extends Node

export var mainGameScene: PackedScene
onready var titleMenu = $TitleMenu
onready var charactermenu = $CharacterMenu

func _toggle_character_menu():
	titleMenu.visible = !titleMenu.visible;
	for node in charactermenu.get_children():
		node.visible = !node.visible

func _on_PlayButton_button_up() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(mainGameScene.resource_path)

#quite the game
func _on_TextureButton_button_up() -> void:
	get_tree().quit()

#character menu opened
func _on_CharacterButton_button_up() -> void:
	_toggle_character_menu()

#exiting the character menu
func _on_CharacterMenu_exit() -> void:
	_toggle_character_menu()
