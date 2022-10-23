extends Node

#Prey 
var weaver;
var roller;
var goaway;
var preys;

#Fields
var spawner_side = false;






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize();
	weaver = preload("res://Actors/Prey/Weaver/Weaver.tscn")
	roller = preload("res://Actors/Prey/Roller/Roller.tscn")
	goaway = preload("res://Actors/Prey/GoAway/GoAway.tscn")
	preys = [ roller, goaway];
	



func _on_Timer_timeout() -> void:
	var prey = preys[randi()%preys.size()].instance()
	var prey_spawn_location

	if spawner_side:
		prey_spawn_location = $LeftPath/LeftPathLocation
		spawner_side = false
	elif !spawner_side:
		print("Reached here!")
		prey_spawn_location = $RightPath/RightPathLocation
		prey.velocity.x *= -1
		spawner_side = true
	prey_spawn_location.unit_offset = randf();
	add_child(prey)
	prey.position = prey_spawn_location.position;
