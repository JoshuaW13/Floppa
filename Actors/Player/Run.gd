# Run.gd
extends PlayerState

func enter(_msg := {}) -> void:
	player.animationPlayer.stop()

func animate()->void:
	if(player.velocity.x <0):
		player.facing = "left"
		player.animationPlayer.play("RunLeft")
	elif(player.velocity.x >0):
		player.facing = "right"
		player.animationPlayer.play("RunRight")

func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("Attack"):
		player.animationPlayer.clear_queue();

func physics_update(_delta: float) -> void:
	animate()
	#Check if jumping
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	#Check if idle
	if is_equal_approx(player.velocity.x,0.0):
		state_machine.transition_to("Idle")
