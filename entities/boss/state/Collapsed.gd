extends "res://entities/boss/BossState.gd"

func enter():
	$CollapseTimer.start()
	
func _on_timer_timeout():
	state_machine.transition_to("Moving")

