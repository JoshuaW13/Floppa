extends Ennemy

#signals
# warning-ignore:unused_signal
signal hit();
#fields
enum states{
	RUN,
	DEAD
}
var state = states.RUN
onready var health = health setget _set_health;
var velocity = Vector2(190,0)
onready var animationPLayer = $AnimationPlayer
onready var damagePlayer = $DamageStateAnimator
onready var hurtbox = $HurtBox/CollisionShape2D
onready var invulnerableTimer = $invulnerableTimer

func _ready() -> void:
	points=5
	_set_health(2);

func init(direction):
	direction = direction.to_lower();
	if direction == "left":
		velocity = Vector2(-150,0)
	elif direction == "right":
		velocity = Vector2(150,0)
	else:
		print("Invalid direction passed!")

func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,3);
	if health != prev_health:
		if health == 0:
			emit_signal("killed",points)

func _damage(value):
	if invulnerableTimer.is_stopped():
		hurtbox.set_deferred("disabled", true);
		invulnerableTimer.start();
	_set_health(health-value)
	damagePlayer.play("Damage");
	damagePlayer.queue("Rest")

func process_run():
	if velocity.x >= 0:
		animationPLayer.play("RunRight")
	elif velocity.x < 0:
		animationPLayer.play("RunLeft")

func process_death():
	if velocity.x > 0:
		animationPLayer.play("DeathRight")
	elif velocity.x < 0:
		animationPLayer.play("DeathLeft")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY*delta;
	if state == states.RUN:
		process_run();
	elif state == states.DEAD:
		process_death()
# warning-ignore:return_value_discarded
	move_and_slide(velocity,FLOOR_NORMAL)	


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_HurtBox_area_entered(_area: Area2D) -> void:
	var player = _area.get_parent().get_parent()	
	_damage(player.attack)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "DeathLeft" or anim_name == "DeathRight":
		velocity.x = 0
		yield(get_tree().create_timer(1), "timeout")
		queue_free()

func _on_Hitbox_area_entered(_area: Area2D) -> void:
	get_tree().call_group("Player","set_knock")

func _on_springbok_killed(_points) -> void:
	print("springbok killed!")
	hurtbox.set_deferred("disabled", true)
	velocity = velocity/1.4;
	state = states.DEAD

func _on_invulnerableTimer_timeout() -> void:
	if state!=states.DEAD:
		hurtbox.set_deferred("disabled", false);
