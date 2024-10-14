extends Node
#fields
var highScore = 0;

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

func _setCharacterInfo(newSpeed, newPower, newHealth, newJump, newSprite):
	speed = newSpeed
	power = newPower
	health = newHealth
	jump = newJump
	spritePath = newSprite
