extends Actor

#constant max player speed
const PLAYER_SPEED = Vector2(175, 500);

#signals
signal health_update(health)
signal killed()

#intitial variables
onready var animationPlayer = $AnimationPlayer;
onready var invulnerableTimer = $InvulnerabilityTimer
onready var damageStatesAnimations = $DamageStateAnimations;
onready var hurtbox = $HurtBox/CollisionShape2D
var facing = "left";
var knock = false;
var attacked = 0;
var animationFree = 1;
var screen_size = Vector2.ZERO;
var velocity;
onready var health = health setget _set_health;

func _ready() -> void:
	velocity = Vector2.ZERO;
	_set_health(3.0); 
	screen_size = get_viewport_rect().size

func damage(amount):
	if invulnerableTimer.is_stopped():
		invulnerableTimer.start()
		hurtbox.set_deferred("disabled", true);
		_set_health(health-amount);
		damageStatesAnimations.play("Damage");
		damageStatesAnimations.queue("Invincibility");

func kill():
	print("Player died!");
	pass
	
func _set_health(value):
	var prev_health = health
	health = clamp(value,0,3)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func set_knock():
	if damageStatesAnimations.current_animation != "Invincibility":
		knock = true;

#calculatte player direction based on input
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		-1.0 if (Input.is_action_just_pressed("jump") and is_on_floor()) or knock else 1.0
		)

#calculate move velocity based on direction and if jump is interrupted dont allow double jumps
func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2, is_jump_interrupted: bool) -> Vector2:
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

#Decide animation state
func _decide_state()-> void:
	#Check for ground attack
	if(Input.is_action_just_pressed("Attack") and is_on_floor()):
		animationFree =0;
		if (facing == "left"):
			animationPlayer.play("AttackLeft");
		elif (facing == "right"):
			animationPlayer.play("AttackRight");
	#Check if player is running
	if(velocity.x < 0 and is_on_floor() and animationFree):
		facing = "left";
		animationPlayer.play("RunLeft");
	elif(velocity.x > 0 and is_on_floor() and animationFree):
		facing = "right"
		animationPlayer.play("RunRight")
	#Check if Idle
	elif( velocity.x == 0.0	and is_on_floor() and facing == "left" and animationFree):
		animationPlayer.play("IdleLeft");
	elif( velocity.x == 0 and is_on_floor() and facing == "right" and animationFree):
		animationPlayer.play("IdleRight")
	#Check if Jumnp animations should start
	elif((animationPlayer.current_animation == "RunLeft" or animationPlayer.current_animation == "IdleLeft")
	and velocity.y <0 and !is_on_floor()):
		facing = "left";
		animationPlayer.play("JumpLeftStart");
	elif((animationPlayer.current_animation == "RunRight" or animationPlayer.current_animation == "IdleRight")
	and velocity.y <0 and !is_on_floor()):
		facing = "right";
		animationPlayer.play("JumpRightStart");
	#Check if attack animations should play	
	elif(Input.is_action_just_pressed("Attack") and !is_on_floor() and attacked == 0):
		attacked = 1
		if (facing == "left"):
			animationPlayer.play("AerialAttackLeft");
		elif (facing == "right"):
			animationPlayer.play("AerialAttackRight");
	


#Some animation states play on finish of others
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "JumpLeftStart":
		animationPlayer.play("JumpLeft");
	elif anim_name == "JumpRightStart":
		animationPlayer.play("JumpRight")
	elif anim_name == "AerialAttackLeft":
		if !is_on_floor():
			animationPlayer.play("JumpLeft");
		elif is_on_floor():
			animationPlayer.play("IdleLeft");
	elif anim_name == "AerialAttackRight":
		if !is_on_floor():
			animationPlayer.play("JumpRight");
		elif is_on_floor():
			animationPlayer.play("IdleRight");
	elif anim_name == "AttackLeft" or anim_name == "AttackRight":
		animationFree = 1;


func _physics_process(delta: float) -> void:
	#print(health)
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y <0.0 #see if jump interupted
	if is_on_floor(): attacked = 0; #Check if can attack again
	var direction = get_direction() #calc direction
	_decide_state(); #deiced animation state
	velocity = calculate_move_velocity(velocity, PLAYER_SPEED, direction, is_jump_interrupted); #calc velocty
	position.x = clamp(position.x, 16, screen_size.x-11);
	position.y = clamp(position.y, 0 ,screen_size.y);
	velocity = move_and_slide(velocity, FLOOR_NORMAL); #move based on that velocity
	

func _on_HurtBox_area_entered(area: Area2D) -> void:
	print("Entered!")
	if(area.name == "biteHitbox"):
		damage(3)
	else:
		damage(1)

func _on_InvulnerabilityTimer_timeout() -> void:
	damageStatesAnimations.play("Rest")
	hurtbox.set_deferred("disabled", false);
