extends Node
#fields
var highScore = 0;
const SERVAL_SCORE = 100;
const LYNX_KILL_COUNT = 10;

#unlocks
var serval = false;
var lynx = false;

#stats
var speed = 3
var power = 3
var health =3
var jump =4
var spritePath = "res://Actors/Player/CaracalIdle-Sheet.png"

#check highscore and update
func check_highscore(score):
	if score > highScore:
		highScore = score;
	if score >= SERVAL_SCORE:
		serval = true

func check_Killed_Ennemies(killedEnnemies):
	if killedEnnemies >= LYNX_KILL_COUNT:
		lynx = true

func _setCharacterInfo(newSpeed, newPower, newHealth, newJump, newSprite):
	speed = newSpeed
	power = newPower
	health = newHealth
	jump = newJump
	spritePath = newSprite
