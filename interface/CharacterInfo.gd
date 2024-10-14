extends TextureRect

signal characterSelected()

onready var characterDataClass = load("res://interface/CharacterData.gd")
var characterArray = Array()
var currentCharacterIndex = 0;

onready var speedBox = $HBoxContainer/statBox/Speed
onready var powerBox = $HBoxContainer/statBox/Power
onready var healthBox = $HBoxContainer/statBox/Health
onready var jumpBox = $HBoxContainer/statBox/Jump
onready var characterImageRect = $HBoxContainer/TextureRect
const caracalSpriteSheetPath = "res://Actors/Player/CaracalIdle-Sheet.png"
const caracalImagePath = "res://CaracaleIcon.png"
const lynxSpriteSheetPath = "res://Actors/Player/Lynx-Sheet.png"
const lynxImagePath = "res://Lynx.png"
func _ready() -> void:
	speedBox._setTexturePath("res://CarcaleIcon.png")
	powerBox._setTexturePath("res://CarcaleIcon.png")
	healthBox._setTexturePath("res://CarcaleIcon.png")
	jumpBox._setTexturePath("res://CarcaleIcon.png")
	_setupCharacterData();	
	_setCharacterStats(characterArray[currentCharacterIndex]);

func _setupCharacterData():
	# Caracal
	var caracalData = characterDataClass.new()
	characterArray.append(_setCharacterData(caracalData,3,3,3,4, caracalSpriteSheetPath, caracalImagePath))
	#Serval
	var servalData = characterDataClass.new()
	characterArray.append(_setCharacterData(servalData,4,3,3,3, caracalSpriteSheetPath, caracalImagePath))
	#Lynx 
	var lynxData = characterDataClass.new()
	characterArray.append(_setCharacterData(lynxData,3,4,2,2, lynxSpriteSheetPath, lynxImagePath))

func _setCharacterData(my_character, speed, power, health, jump, sprite, image):
	my_character.speedValue =speed
	my_character.powerValue = power
	my_character.healthValue = health
	my_character.jumpValue = jump
	my_character.spritePath = sprite
	my_character.imagePath = image
	return my_character

func _setCharacterStats(my_character):
	speedBox._setStatValue(my_character.speedValue)
	powerBox._setStatValue(my_character.powerValue)
	healthBox._setStatValue(my_character.healthValue)
	jumpBox._setStatValue(my_character.jumpValue )
	characterImageRect.set_texture(load(my_character.imagePath))

func _updateCharacter():
	_setCharacterStats(characterArray[currentCharacterIndex]);	

func _on_LeftButton_button_down() -> void:
	if currentCharacterIndex==0:
		currentCharacterIndex = 2
	else: 
		currentCharacterIndex -=1
	_updateCharacter()	


func _on_RightButton_button_down() -> void:
	if currentCharacterIndex==2:
		currentCharacterIndex = 0
	else: 
		currentCharacterIndex +=1
	_updateCharacter()


func _on_TextureButton_button_down() -> void:
	#set character data
	var my_character = characterArray[currentCharacterIndex];
	PlayerData._setCharacterInfo(my_character.speedValue, my_character.powerValue,my_character.healthValue,my_character.jumpValue, my_character.spritePath)	
	emit_signal("characterSelected")
