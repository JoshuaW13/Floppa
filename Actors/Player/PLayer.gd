extends Actor

#constant max player speed
const PLAYER_SPEED = Vector2(175, 500);

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

#Animation State Handlers
func idle_state():
	if !is_on_floor():
		state = states.JUMP
		start_jump_anim()
		return
	if Input.is_action_just_pressed("Attack"):
		attack()
	if !animationFree:
		return
	if facing == "left":
		animationPlayer.play("IdleLeft")
	if facing == "right":
		animationPlayer.play("IdleRight")
	if velocity.x != 0:
		state = states.RUN

func run_state():
	if !is_on_floor():
		state = states.JUMP
		start_jump_anim()
		return
	if Input.is_action_just_pressed("Attack"):
		attack()
	if !animationFree:
		return
	if velocity.x < 0:
		facing = "left"
		animationPlayer.play("RunLeft")
	if velocity.x > 0:
		facing = "right"
		animationPlayer.play("RunRight")
	if velocity.x == 0:
		state = states.IDLE

func attack():
	animationFree = 0;
	if facing == "left":
		animationPlayer.play("AttackLeft")
	if facing == "right":
		animationPlayer.play("AttackRight")

func start_jump_anim():
	if facing == "left":
		animationPlayer.play("JumpLeftStart")
		animationPlayer.queue("JumpLeft")
	if facing == "right":
		animationPlayer.play("JumpRightStart")
		animationPlayer.queue("JumpRight")

func jump_state():
	if is_on_floor():
		state = states.IDLE
		attacked =0
		return
	if Input.is_action_just_pressed("Attack"):
		if attacked == 0: 
			aerial_attack()

func aerial_attack():
	attacked = 1
	if facing == "left":
		animationPlayer.play("AerialAttackLeft")
		animationPlayer.queue("JumpLeft")
	if facing == "right":
		animationPlayer.play("AerialAttackRight")
		animationPlayer.queue("JumpRight")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	animationFree = 1
	if anim_name == "AttackLeft":
		animationPlayer.play("IdleLeft")
	if anim_name == "AttackRight":
		animationPlayer.play("IdleRight")

func _physics_process(delta: float) -> void:
	#print(health)
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y <0.0 #see if jump interupted
	if is_on_floor(): attacked = 0; #Check if can attack again
	var direction = get_direction() #calc direction
	#handle animation state
	match state:
		states.IDLE:
			idle_state()
		states.RUN:
			run_state()
		states.JUMP:
			jump_state()
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
