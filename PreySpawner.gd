extends Node

#signals
signal Ennemy;
signal pointScored;

#Prey 
var weaver;
var roller;
var goaway;
var preys;

#Fields
var spawner_side_ = 0;
onready var timer = $Timer
onready var soundPlayer = $PreynewWavePlayer
var wave = 0;
var inter_wave = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize();
	weaver = preload("res://Actors/Prey/WeaverBird/WeaverBird.tscn")
	roller = preload("res://Actors/Prey/Roller/Roller.tscn")
	goaway = preload("res://Actors/Prey/GoAway/GoAway.tscn")
	preys = [goaway];

func _endless_spawn(spawner_side, prey, prey_spawn_location,i)->void:
	if (i == 2) and (wave%3 ==0):
		prey =roller.instance();
	else:
		prey = preys[randi()%preys.size()].instance();
	spawner_side = randi()%2;
	if spawner_side == 1:
		prey_spawn_location = $LeftPath/LeftPathLocation
	elif spawner_side == 0:
		prey_spawn_location = $RightPath/RightPathLocation
		prey.velocity.x *= -1
	prey_spawn_location.unit_offset = randf();
	prey.connect("killed", self, "_on_prey_killed")
	add_child(prey)
	prey.position = prey_spawn_location.position;

func _on_Timer_timeout() -> void:
	#start ennemy spawner
	if wave ==2:
		emit_signal("Ennemy");
		wave += 1;
		return

	var prey ;
	spawner_side_ = randi()%2;
	var prey_spawn_location;
	
	#early wave scripting
	if wave ==0:
		#print("wave 0")
		prey = weaver.instance();
	if wave <2 && wave != 0:
		#print("reached here!")
		prey = preys[randi()%preys.size()].instance()
		timer.wait_time = 10;
		preys.append(weaver)
	if wave >2:
		if inter_wave==0:
			timer.wait_time=1.5;
			timer.start()
		elif inter_wave==3:
			timer.wait_time=4;
			timer.start()
			wave+=1
			soundPlayer.play()
			#print("endless wave finished")
			inter_wave=0;
			return
		_endless_spawn(spawner_side_, prey, prey_spawn_location,inter_wave);
		inter_wave+=1;
		return;

	#Choose spawner side
	if spawner_side_ == 1:
		prey_spawn_location = $LeftPath/LeftPathLocation
	elif spawner_side_ == 0:
		prey_spawn_location = $RightPath/RightPathLocation
		prey.velocity.x *= -1

	#Apply offset and add prey animal
	prey_spawn_location.unit_offset = randf();
	prey.connect("killed", self, "_on_prey_killed")
	add_child(prey)
	prey.position = prey_spawn_location.position;
	#print("wave finsihed")
	wave +=1;
	soundPlayer.play()

#signal responses
func _on_prey_killed(points):
	emit_signal("pointScored",points)
