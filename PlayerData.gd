extends Node
#fields
var highScore = 0;
const SERVAL_SCORE = 75;
const LYNX_KILL_COUNT = 10;

#unlocks
var serval = false;
var lynx = false;
signal character_unlocked(notificationText)

enum characters {
	FLOPPA=0,
	SERVAL=1,
	LYNX=2
}

#stats
var currentCharacter = characters.FLOPPA
var speed = 3
var power = 3
var health =3
var jump =3
var spritePath = "res://Actors/Player/CaracalIdle-Sheet.png"
var attackSpeed = 1.0

#check highscore and update
func check_highscore(score):
	if score > highScore:
		highScore = score;
	if score >= SERVAL_SCORE && !serval:
		serval = true
		emit_signal("character_unlocked", "Serval Unlocked!")		

func check_Killed_Ennemies(killedEnnemies):
	if killedEnnemies >= LYNX_KILL_COUNT && !lynx:
		lynx = true
		emit_signal("character_unlocked", "Lynx Unlocked!")

func _setCharacterInfo(character, newSpeed, newPower, newHealth, newJump, newSprite):
	currentCharacter = character
	speed = newSpeed
	power = newPower
	health = newHealth
	jump = newJump
	spritePath = newSprite
