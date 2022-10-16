extends Actor

var speedArray = [60,70];
var frequencyArray = [2,3,4,5,6];
var amplitudeArray = [1.0,1.5,1.75]
var velocity;
var time = 0;
var frequency;
var amplitude;
onready var animationplayer = $AnimationPlayer;
func _ready() -> void:
	#randomize weaver sinusoidal mouvement pattern
	randomize();
	velocity = Vector2(speedArray[randi()%speedArray.size()],0);
	frequency = frequencyArray[randi()%frequencyArray.size()];
	amplitude = amplitudeArray[randi()%amplitudeArray.size()];
	
func _decideAnimation() ->void:
	if(velocity.x >= 0):
		animationplayer.play("FlyRight");
	elif(velocity.x <0):
		animationplayer.play("FlyLeft");

func determine_ypos()->float:
	time += get_physics_process_delta_time();
	var mouvement = cos(frequency*time)*amplitude;
	return mouvement;
	

func _physics_process(delta: float) -> void:
	_decideAnimation();
	position.y += determine_ypos();
	move_and_slide(velocity);
