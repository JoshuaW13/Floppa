extends TextureRect

signal characterSelected()

onready var characterDataClass = load("res://interface/CharacterData.gd")
var characterArray = Array()
var currentCharacterIndex = 0;

onready var statBox = $HBoxContainer/statBox
onready var speedBox = $HBoxContainer/statBox/Speed
onready var powerBox = $HBoxContainer/statBox/Power
onready var healthBox = $HBoxContainer/statBox/Health
onready var jumpBox = $HBoxContainer/statBox/Jump
onready var characterImageRect = $HBoxContainer/TextureRect
onready var toolTipButton = $HBoxContainer/TextureButton/ColorRect/Label
onready var characterSelector = $HBoxContainer/TextureButton
const LOCKED_SPRITE = "res://interface/images/Locked.png"
const PLAY_IMAGE = "res://interface/images/PlayButtonPressed.png"
const caracalSpriteSheetPath = "res://Actors/Player/CaracalIdle-Sheet.png"
const caracalImagePath = "res://CaracaleIcon.png"
const lynxSpriteSheetPath = "res://Actors/Player/Lynx-Sheet.png"
const lynxImagePath = "res://Lynx.png"
const LYNX_TOOLTIP = "Kill 10 Hostile Animals"
const servalSpriteSheetPath = "res://Actors/Player/Serval-Sheet.png"
const servalImagePath = "res://Serval.png"
const SERVAL_TOOLTIP = "Achieve Score of 100"
func _ready() -> void:
	speedBox._setTexturePath("res://CarcaleIcon.png")
	powerBox._setTexturePath("res://CarcaleIcon.png")
	healthBox._setTexturePath("res://interface/images/healthIcon.png")
	jumpBox._setTexturePath("res://CarcaleIcon.png")
	_setupCharacterData();	
	_setCharacterStats(characterArray[currentCharacterIndex]);

func _setupCharacterData():
	# Caracal
	var caracalData = characterDataClass.new()
	characterArray.append(_setCharacterData(caracalData,3,3,3,4, caracalSpriteSheetPath, caracalImagePath, ""))
	#Serval
	var servalData = characterDataClass.new()
	characterArray.append(_setCharacterData(servalData,4,3,3,3, servalSpriteSheetPath, servalImagePath, SERVAL_TOOLTIP))
	#Lynx 
	var lynxData = characterDataClass.new()
	characterArray.append(_setCharacterData(lynxData,3,4,2,2, lynxSpriteSheetPath, lynxImagePath, LYNX_TOOLTIP))

func _setCharacterData(my_character, speed, power, health, jump, sprite, image, tooltip):
	my_character.speedValue =speed
	my_character.powerValue = power
	my_character.healthValue = health
	my_character.jumpValue = jump
	my_character.spritePath = sprite
	my_character.imagePath = image
	my_character.toolTip = tooltip
	return my_character

func _setCharacterStats(my_character):
	speedBox._setStatValue(my_character.speedValue)
	powerBox._setStatValue(my_character.powerValue)
	healthBox._setStatValue(my_character.healthValue)
	jumpBox._setStatValue(my_character.jumpValue )
	characterImageRect.set_texture(load(my_character.imagePath))
	if(!_character_unlocked(currentCharacterIndex)):
		characterSelector.unlocked = false
		characterImageRect.modulate = Color(1,1,1,0.5)
		characterSelector.set_normal_texture(load(LOCKED_SPRITE))
		toolTipButton.text = my_character.toolTip
		characterSelector.set_disabled(true)
	else:
		characterSelector.unlocked = true		
		characterImageRect.modulate = Color(1,1,1,1)
		characterSelector.set_normal_texture(load(PLAY_IMAGE))
		characterSelector.set_disabled(false)

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

func _character_unlocked(currentCharacterIndex: int):
	match currentCharacterIndex:
		1:
			if !PlayerData.serval:
				return false
		2:
			if !PlayerData.lynx:
				return false
	return true


func _on_TextureButton_button_down() -> void:
	#set character data
	var my_character = characterArray[currentCharacterIndex];
	if(!_character_unlocked(currentCharacterIndex)):
		return
	PlayerData._setCharacterInfo(my_character.speedValue, my_character.powerValue,my_character.healthValue,my_character.jumpValue, my_character.spritePath)	
	emit_signal("characterSelected")
