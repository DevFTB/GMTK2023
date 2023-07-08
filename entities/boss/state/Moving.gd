extends "res://entities/boss/BossState.gd"

func process_input(event: InputEvent):
	if event is InputEventKey:
		var axis = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		boss.movement_dir = axis
		
		if event.is_action_pressed("activate_combo_1"):
			boss.activate_combo(0)
			state_machine.transition_to("Attacking")
			
		if event.is_action_pressed("activate_combo_2"):
			boss.activate_combo(1)
			state_machine.transition_to("Attacking")
