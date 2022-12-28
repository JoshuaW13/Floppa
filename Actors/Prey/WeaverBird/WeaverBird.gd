extends Prey

var frequencyArray = [2,3,4,5,6];
var amplitudeArray = [1.0,1.5,1.75]
var time = 0;
var frequency;
var amplitude;
onready var animationplayer = $AnimationPlayer
var velocity = Vector2(60.0, 0.0);

func _ready() -> void:
	#randomize weaver sinusoidal mouvement pattern
	points = 1;
	randomize();
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

#bird exits screen
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

#bird is killed
func _on_Hurtbox_area_entered(area: Area2D) -> void:
	emit_signal("killed",points)
	queue_free()

#bird exits tree
func _on_WeaverBird_tree_exited() -> void:
	queue_free()
