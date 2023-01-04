extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.animationPlayer.stop()

func animate()->void:
	if(player.facing == "left"):
		player.animationPlayer.queue("IdleLeft")
	else:
		player.animationPlayer.queue("IdleRight")

func handle_input(_event: InputEvent) -> void:
	pass
#	if _event.is_action_pressed("Attack"):
#		player.animationPlayer.clear_queue();
#		if(player.facing=="left"):
#			player.animationPlayer.play("AttackLeft")
#		elif(player.facing=="right"):
#			player.animationPlayer.play("AttackRight")

func physics_update(_delta: float) -> void:
	#print("Is in idle state")
	animate()
	if not player.is_on_floor():
		state_machine.transition_to("Jump")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	elif (Input.is_action_pressed("MoveLeft") or Input.is_action_pressed("MoveRight"))and player.velocity.x != 0:
		state_machine.transition_to("Run")
