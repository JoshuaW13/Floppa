# Jump.gd
extends PlayerState

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	#start the start of jump animation
	if(player.facing == 'left'):
		player.animationPlayer.play("JumpLeftStart")
		player.animationPlayer.queue("JumpLeft")
	elif(player.facing == 'right'):
		player.animationPlayer.play("JumpRightStart")
		player.animationPlayer.queue("JumpRight")

func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("Attack"):
		player.animationPlayer.clear_queue();
		if(player.facing=="left"):
			player.animationPlayer.play("AerialAttackLeft")
			player.animationPlayer.queue("JumpLeft")
		elif(player.facing=="right"):
			player.animationPlayer.play("AerialAttackRight")
			player.animationPlayer.queue("JumpRight")

func physics_update(delta: float) -> void:
	#print("Is jumping")
	#print(player.facing)
	# Landing.
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
