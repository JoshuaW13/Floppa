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
onready var deathSound = $deathSound
onready var chirp = $Chirp
var state = FLYING;
var velocity = Vector2((randi()%75+55), 0.0)

func _ready() -> void:
	points = 2

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
	var _newVector = move_and_slide(velocity);


func _on_Area2D_body_entered(_body: Node) -> void:
	if threatDetected:
		return
	if velocity.x <= 0:
		animationPlayer.play("DeathLeft");
	elif velocity.x >0:
		animationPlayer.play("DeathRight");
	threatDetected = true;
	if !deathSound.playing:
		chirp.play()
	detectionBox.set_deferred("disabled", true);
	
	velocity.y = -120


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free();

#goaway bird killed
func _on_HurtBox_area_entered(_area: Area2D) -> void:
	hide()
	chirp.stop()
	deathSound.play()
	hurtbox.set_deferred("disabled", true)
	emit_signal("killed",points)	


func _on_deathSound_finished() -> void:
	queue_free();
