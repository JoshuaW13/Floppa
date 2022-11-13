extends Actor

#signals
signal killed()
#fields
enum states{
	RUN,
	DEAD
}
var state = states.RUN
onready var health = health setget _set_health;
var velocity = Vector2(150,0)
onready var animationPLayer = $AnimationPlayer
onready var damagePlayer = $DamageStateAnimator
onready var hurtbox = $HurtBox/CollisionShape2D

func _ready() -> void:
	_set_health(2);

func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,3);
	if health != prev_health:
		if health == 0:
			emit_signal("killed")

func _damage(value):
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
	move_and_slide(velocity,FLOOR_NORMAL)	


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_HurtBox_area_entered(area: Area2D) -> void:
	_damage(1);


func _on_springbok_killed() -> void:
	print("killed!")
	hurtbox.set_deferred("disabled", true)
	velocity = velocity/1.4;
	state = states.DEAD


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "DeathLeft" or anim_name == "DeathRight":
		velocity.x = 0
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
