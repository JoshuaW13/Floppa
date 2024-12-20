extends Prey

enum {
	FLYING,
	DEATH
}
onready var animationplayer = $AnimationPlayer
onready var detection = $Area2D/DetectionRange
onready var deathSound = $deathSound
onready var hurtbox = $Hitbox/collisionshape
onready var chirp = $chirp
#fields
var threatDetected = false; 
var state = FLYING
var velocity = Vector2(95.0,0.0);

func _ready() -> void:
	points = 5;

func _decideAnimation() ->void:
	if threatDetected:
		return
	elif(velocity.x >= 0):
		animationplayer.play("FlyRight");
	elif(velocity.x <0):
		animationplayer.play("FlyLeft");	

func deathVelocity()->void:
	velocity.y = 150
	velocity.x = -velocity.x/velocity.x

func _physics_process(_delta: float) -> void:
	if position.y>= 180 and state==DEATH:
		queue_free();
	_decideAnimation();
	var _newVector = move_and_slide(velocity);

func _on_Area2D_body_entered(_body: Node) -> void:
	#threat detected flag ensures status change wont keep happening
	detection.set_deferred("disabled", true);
	if !threatDetected:
		velocity.x *=-2
	if velocity.x >=0:
			animationplayer.play("FastFlyRight")
	elif velocity.x <= 0:
			animationplayer.play("FastFlyLeft");
	
	threatDetected = true;
	if !deathSound.playing:
		chirp.play()

#Destroys if exits screen
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

#roller killed
func _on_Hitbox_area_entered(_area: Area2D) -> void:
	hide()
	hurtbox.set_deferred("disabled", true)
	emit_signal("killed",points)
	chirp.stop()
	deathSound.play()

func _on_deathSound_finished() -> void:
	queue_free()
