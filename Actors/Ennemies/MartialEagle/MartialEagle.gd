extends Ennemy

#variables
enum states{
	SOAR,
	DOWN,
	UP
}
var health = health setget _set_health;
var state = states.SOAR;
var VELOCITY = Vector2(60,0)
var UP = Vector2(100,-100)
var speed = 150;
var target = null;
onready var animationPlayer = $AnimationPlayer
onready var damagePlayer = $DamagePlayer
onready var detection = $Detection/CollisionShape2D

func _ready() -> void:
	points = 5
	detection.set_deferred("disabled", true)
	_set_health(2)

func init(direction):
	direction = direction.to_lower();
	if direction == "left":
		VELOCITY = Vector2(-60,0)
		UP = Vector2(-100,-100)
	elif direction == "right":
		VELOCITY = Vector2(60,0)
		UP = Vector2(100,-100)
	else:
		print("Invalid direction passed!")

#health functions
func _set_health(value):
	var prev_health = health
	health = clamp(value,0,2)
	if health != prev_health:
		if health == 0:
			emit_signal("killed",points)
			emit_signal("killed")

func damage(value):
	_set_health(health-value)
	UP = UP/1.2
	damagePlayer.play("Damage")
	damagePlayer.queue("Rest")

#animation state hanlders
func soar(velocity):
	if(velocity.x<0):
		animationPlayer.play("SoarLeft")
	if(velocity.x>=0):
		animationPlayer.play("SoarRight")

func dive(velocity):
	if(velocity.x<0):
		animationPlayer.play("SwoopLeft")
	if(velocity.x>=0):
		animationPlayer.play("SwoopRight")

func rise(velocity):
	if(velocity.x<0):
		animationPlayer.play("FlapLeft")
	if(velocity.x>=0):
		animationPlayer.play("FlapRight")
	
	

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	#animation state manager
	match state:
		states.SOAR:
			velocity = VELOCITY;
			soar(velocity)
		states.DOWN:
			#print(position.distance_to(target))
			if position.distance_to(target)<2:
				state = states.UP
				target = null;
				velocity = Vector2.ZERO
			elif target != null:
				velocity = position.direction_to(target)*speed
			else:
				print("soaring without target")
			dive(velocity);
		states.UP:
			velocity = UP
			rise(velocity);
	
	velocity = move_and_slide(velocity,FLOOR_NORMAL)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	#print("destroyed!");
	queue_free();

#eagle detects player
func _on_Detection_area_entered(area: Area2D) -> void:
	#print("detected!",area.name)
	detection.set_deferred("disabled", true)
	target = area.global_position;
	target.y -=15
	#print("Targets ",target)
	state = states.DOWN;

#ealge is damaged
func _on_HurtBox_area_entered(area: Area2D) -> void:
	#print("damged!")
	damage(1)


func _on_VisibilityNotifier2D_screen_entered() -> void:
	detection.set_deferred("disabled", false)


func _on_eagle_killed() -> void:
	queue_free()
