class_name Player
extends Actor

#constant max player speed
var player_speed = Vector2(175, 450) setget _set_player_speed;

#signals
signal health_update(health)
signal killed()

#intitial variables
enum states{
	IDLE,
	RUN,
	JUMP,
}
var state = states.IDLE
onready var animationPlayer = $AnimationPlayer;
onready var invulnerableTimer = $InvulnerabilityTimer
onready var damageStatesAnimations = $DamageStateAnimations;
onready var hurtbox = $HurtBox/CollisionShape2D
onready var sprite = $Sprite
onready var hurtSound = $SoundEffects/Damage
onready var boneCrushedSound = $SoundEffects/Eaten

var facing = "left";
var knock = false;
var attacked = 0;
var animationFree = 1;
var screen_size = Vector2.ZERO;
var velocity;
var attackAnimationSpeed = 1.0
onready var health = health setget _set_health;
export onready var attack = attack setget _set_attack;

func _ready() -> void:
	velocity = Vector2.ZERO;
	_set_health(PlayerData.health); 
	_set_player_speed(PlayerData.speed)
	_set_attack(PlayerData.power)
	_set_player_jump_speed(PlayerData.jump)
	sprite.set_texture(load(PlayerData.spritePath))
	screen_size = get_viewport_rect().size

func damage(amount):
	if invulnerableTimer.is_stopped():
		invulnerableTimer.start()
		hurtbox.set_deferred("disabled", true);
		_set_health(health-amount);
		damageStatesAnimations.play("Damage");
		damageStatesAnimations.queue("Invincibility");

func kill():
	emit_signal("killed");
	
func _set_health(value):
	var prev_health = health
	health = clamp(value,0,4)
	if health != prev_health:
		emit_signal("health_update", health)
		if health == 0:
			print("Hurtbox should be disabled!");
			hurtbox.set_deferred("disabled", true);
			hide()
			kill();

func _set_player_speed(value):
	var newSpeed = player_speed.x
	if value ==2:
		newSpeed = 2.5*58
	else:
		newSpeed = value*58
	player_speed.x = newSpeed

func _set_player_jump_speed(value):
	var newSpeed = player_speed.y
	match value:
		2:
			newSpeed = newSpeed * 0.80
		4:
			newSpeed = newSpeed*1.45
			GRAVITY = 1500
	player_speed.y = newSpeed

func _set_attack(value):
	match value:
		3:
			attack = 1
			return
		4:
			attack = 2
			return
	attack = 1;

func set_knock():
	if damageStatesAnimations.current_animation != "Invincibility":
		knock = true;

#calculatte player direction based on input
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		-1.0 if (Input.is_action_just_pressed("jump") and is_on_floor()) or knock else 1.5
		)

#calculate move velocity based on direction and if jump is interrupted dont allow double jumps
func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2, is_jump_interrupted: bool) -> Vector2:
	if health ==0:
		return Vector2(0,0)
	var out = linear_velocity
	out.y += GRAVITY*get_physics_process_delta_time()
	if !animationFree:
		out.x = 0;
		return out;
	out.x = speed.x*direction.x
	if direction.y == -1.0:
		out.y = jump(speed, direction)
	if is_jump_interrupted:
		out.y =0.0
	if knock:
		speed.y = speed.y/1.1
		out.y = jump(speed, direction);
		knock = false;
	return out

func jump(speed: Vector2, direction: Vector2):
	return speed.y*direction.y

func _physics_process(_delta: float) -> void:
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y <0.0 #see if jump interupted
	if is_on_floor(): attacked = 0; #Check if can attack again
	var direction = get_direction() #calc direction
	#calculate velocity and move player
	velocity = calculate_move_velocity(velocity, player_speed, direction, is_jump_interrupted); #calc velocty
	position.x = clamp(position.x, 16, screen_size.x-11);
	position.y = clamp(position.y, 0 ,screen_size.y);
	velocity = move_and_slide(velocity, FLOOR_NORMAL); #move based on that velocity
	
#damage player
func _on_HurtBox_area_entered(area: Area2D) -> void:
	if(area.name == "biteHitbox"):
		boneCrushedSound.play();
		damage(3)
	else:
		hurtSound.play();
		damage(1)

#give player invincibility
func _on_InvulnerabilityTimer_timeout() -> void:
	damageStatesAnimations.play("Rest")
	if health>0:
		hurtbox.set_deferred("disabled", false);

func _on_SoundEffects_soundFinished() -> void:
	if health == 0:
		queue_free()
