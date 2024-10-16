extends Prey

enum {
	FLYING,
	DEATH
}

#fields
var threatDetected = false
onready var animationPlayer = $AnimationPlayer
onready var detectionBox = $Area2D/DetectionBox
onready var hurtbox = $HurtBox/hitbox
var state = FLYING;
var velocity = Vector2((randi()%75+55), 0.0)

func _ready() -> void:
	points = 1

func _decideAnimation()->void:
	if threatDetected:
		return
	elif velocity.x <=0:
		if state == FLYING:
			animationPlayer.play("FlyLeft")
		else:
			animationPlayer.play("DeathLeft")
	elif velocity.x >0:
		if state == FLYING:
			animationPlayer.play("FlyRight")
		else:
			animationPlayer.play("DeathRight")



func _physics_process(_delta: float) -> void:
	if position.y>= 180 and state==DEATH:
		queue_free();
	_decideAnimation()
	move_and_slide(velocity);


func _on_Area2D_body_entered(_body: Node) -> void:
	if threatDetected:
		return
	if velocity.x <= 0:
		animationPlayer.play("DeathLeft");
	elif velocity.x >0:
		animationPlayer.play("DeathRight");
	threatDetected = true;
	detectionBox.set_deferred("disabled", true);
	
	velocity.y = -120


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free();

#goaway bird killed
func _on_HurtBox_area_entered(_area: Area2D) -> void:
	detectionBox.set_deferred("disabled", true);
	#state = DEATH;
	#velocity.y = 100;
	#hurtbox.set_deferred("disabled", true);
	emit_signal("killed",points)
	queue_free();
