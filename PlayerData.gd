extends Node
#fields
var highScore = 0;

#check highscore and update
func check_highscore(score):
	if score > highScore:
		highScore = score;
