extends AudioStreamPlayer2D

func play_action_sound(action: BossAction):
	stream = action.hit_sound
	play()


func _on_boss_state_machine_state_entered(state):
	if state.enter_sound != null:
		stream = state.enter_sound
		play()
	pass # Replace with function body.


func _on_boss_state_machine_state_exited(state):
	if state.exit_sound != null:
		stream = state.exit_sound
		play()
	pass # Replace with function body.
