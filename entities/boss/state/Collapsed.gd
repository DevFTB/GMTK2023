extends "res://entities/boss/BossState.gd"

func enter():
	boss.movement_dir = Vector2.ZERO
	animator.play("collapsing")
	$CollapseTimer.start()
	
func exit():
	animator.play("uncollapsing")
	await animator.animation_finished
	
func _on_timer_timeout():
	state_machine.transition_to("Moving")

