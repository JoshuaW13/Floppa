extends HBoxContainer

var texturePath = ""
onready var textureRect = $TextureRect
onready var label = $Label

func _ready() -> void:
	pass

func _setTexturePath(newTexturePath):
	textureRect.texture = load(newTexturePath)

func _setStatValue(newStat):
	label.text = str(newStat)
