extends Ennemy

#fields
var HYENA_WALK_SPEED;
var HYENA_RUN_SPEED;
enum states{
	WALK,
	ATTACK,
	FLEE
}
var state = states.WALK
var damage = 1.0;
var velocity = Vector2(-30,0.0);
onready var health = health setget _set_health;
onready var invulnerableTimer = $InvulnerableTimer
onready var animationPlayer = $AnimationPlayer
onready var damagePLayer = $DamageStatePlayer
onready var biteHitbox = $biteHitbox/CollisionShape2D
onready var detectionBox = $DetectionBox/CollisionShape2D
onready var hurtBox = $HurtBox/CollisionShape2D

func _ready() -> void:
	_set_health(4)
	points = 8;
	biteHitbox.set_deferred("disabled", true);

func init(direction):
	direction = direction.to_lower();
	if direction == "left":
		HYENA_WALK_SPEED = Vector2(-30,0)
	elif direction == "right":
		HYENA_WALK_SPEED = Vector2(30,0)
	else:
		print("Invalid direction passed!")
	velocity = HYENA_WALK_SPEED;
	HYENA_RUN_SPEED = HYENA_WALK_SPEED*-4

func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,6);
	if health != prev_health:
		if health == 0:
			emit_signal("killed",points)

func _damage(value):
	if invulnerableTimer.is_stopped():
		hurtBox.set_deferred("disabled", true);
		invulnerableTimer.start()
	_set_health(health-value)
	damagePLayer.play("Damage");
	damagePLayer.queue("Rest")


func _process_walk()->void:
	if velocity.x < 0:
		animationPlayer.play("WalkLeft");
	elif velocity.x >= 0:
		animationPlayer.play("WalkRight");
	
func _process_attack()->void:
	if animationPlayer.current_animation == "WalkLeft":
		animationPlayer.play("AttackLeft")
	if animationPlayer.current_animation == "WalkRight":
		animationPlayer.play("AttackRight")

func _process_flee()->void:
	if velocity.x <=0:
		animationPlayer.play("RunLeft");
	if velocity.x >0:
		animationPlayer.play("RunRight");

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY*delta
	if state == states.WALK:
		_process_walk();
	if state == states.ATTACK:
		_process_attack();
	if state == states.FLEE:
		_process_flee();
	move_and_slide(velocity, FLOOR_NORMAL);

#Player enteres hyena's bite detect area
func _on_DetectionBox_area_entered(_area: Area2D) -> void:
	state = states.ATTACK;
	velocity.x = 0;

#Player leaves hyena's bite detec area
func _on_DetectionBox_area_exited(_area: Area2D) -> void:
	biteHitbox.set_deferred("disabled",true)
	if state == states.FLEE:
		return
	state = states.WALK;
	velocity = HYENA_WALK_SPEED

#Player hits brown hyena
func _on_HurtBox_area_entered(area: Area2D) -> void:
	if area.name == "HurtBox":
		return
	var player = area.get_parent().get_parent()	
	_damage(player.attack)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free();


func _on_brownhyena_killed(_points) -> void:
	state = states.FLEE
	biteHitbox.set_deferred("disabled", true);
	hurtBox.set_deferred("disabled", true);
	detectionBox.set_deferred("disabled", true)
	velocity = HYENA_RUN_SPEED


func _on_InvulnerableTimer_timeout() -> void:
	if state!=states.FLEE:
		hurtBox.set_deferred("disabled", false);
