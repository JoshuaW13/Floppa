extends Node

#other vars
onready var timer = $Timer
var wave = 0;

#ennemies
var eagle;
var hyena;
var deer;
var num_hyenas = 0;
var ennemies;
var aerials;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize();
	eagle = preload("res://Actors/Ennemies/MartialEagle/MartialEagle.tscn")
	hyena = preload("res://Actors/Ennemies/BrownHyena/brownHyena.tscn")
	deer = preload("res://Actors/Ennemies/Springbok/springbok.tscn")
	ennemies = [hyena, deer];
	aerials = [eagle];

func spawn_ennemy():
	var en;
	var ennemyLocation;
	if wave == 0:
		timer.stop()
		en = hyena.instance();
		timer.wait_time = 10;
		timer.start()
	else:
		var temp = ennemies[randi()%ennemies.size()];
		if temp==hyena:
			num_hyenas+=1;
		else:
			num_hyenas=0;
		if num_hyenas==3:
			print("entered here!")
			while temp ==hyena:
				temp=ennemies[randi()%ennemies.size()]
			num_hyenas=0;
		en = temp.instance();
	var side = randi()%2;
	#decide the side
	if side == 0:
		en.init("right")
		ennemyLocation = $LeftGround
	elif side == 1:
		en.init("left")
		ennemyLocation = $RightGround
	#ennemyLocation.unit_offset = randf();
	add_child(en);
	en.position = ennemyLocation.position;

func spawn_aerial():
	var en;
	var ennemyLocation;
	if wave == 0:
		timer.stop()
		en = eagle.instance();
		timer.wait_time = 10;
		timer.start()
	else:
		var temp = aerials[randi()%aerials.size()]
		en = temp.instance();
	var side = randi()%2;
	#decide the side
	if side == 0:
		en.init("right")
		ennemyLocation = $LeftAerial/LeftPathLocation
	elif side == 1:
		en.init("left")
		ennemyLocation = $RightAerial/RightPathLocation
	ennemyLocation.unit_offset = randf();
	add_child(en);
	en.position = ennemyLocation.position;

func _on_Timer_timeout() -> void:
	var numEnem = 1;
	if wave  >=2 and wave <5:
		numEnem = 2
	elif wave>=5:
		numEnem = wave/5+2

	for i in numEnem:
		var altitude = randi()%3;
		if altitude ==1:
			spawn_aerial()
		elif altitude == 0or altitude==2:
			spawn_ennemy()
		yield(get_tree().create_timer(2), "timeout")
		#print("spawned")
	wave+=1;
	#print("wave over")

#turns on ennemy spawn in sync with prey spawner
func _on_PreySpawner_Ennemy() -> void:
	timer.autostart = true;
	timer.start()
