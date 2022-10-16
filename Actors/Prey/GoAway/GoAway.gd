extends Actor

#fields
var velocity = Vector2(-70.0, 0.0);
onready var animationPlayer = $AnimationPlayer
onready var detectionBox = $Area2D/DetectionBox

func _decideAnimation()->void:
	if velocity.x <=0:
		animationPlayer.play("FlyLeft")
	elif velocity.x >0:
		animationPlayer.play("FlyRight")

func _physics_process(delta: float) -> void:
	_decideAnimation()
	move_and_slide(velocity);
