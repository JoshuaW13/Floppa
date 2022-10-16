extends Actor


onready var animationplayer = $AnimationPlayer
#fields
var velocity = Vector2(90.0,0.0);
var threatDetected = false; 

func _decideAnimation() ->void:
	if threatDetected:
		return
	elif(velocity.x >= 0):
		animationplayer.play("FlyRight");
	elif(velocity.x <0):
		animationplayer.play("FlyLeft");	


func _physics_process(delta: float) -> void:
	_decideAnimation();
	move_and_slide(velocity);


func _on_Area2D_body_entered(body: Node) -> void:
	if !threatDetected:
		velocity *=-2
	if velocity.x >=0:
			animationplayer.play("FastFlyRight")
	elif velocity.x <= 0:
			animationplayer.play("FastFlyLeft");
	
	threatDetected = true;



