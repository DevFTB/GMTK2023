extends "res://entities/boss/BossState.gd"



func enter():
	boss.movement_dir = Vector2.ZERO
	boss.active_combo.failed.connect(_on_combo_failed)
	boss.active_combo.completed.connect(_on_combo_completed)
	
	boss.active_combo.action_started.connect(func(action): play_started_animation(action))
	boss.active_combo.action_hit.connect(func(action, strength): play_hit_animation(action))
	pass


func play_started_animation(action :BossAction):
	animator.play(action.starting_animation)
	
	if action.is_hold_action:
		await animator.animation_finished
		animator.play(action.sustain_animation)
	pass

func play_hit_animation(action : BossAction):
	animator.play(action.hit_animation)
	pass


func process_input(event: InputEvent):
	pass
	
func update(delta: float) -> void:
	pass
	
func _on_combo_completed():
	state_machine.transition_to("Moving")

func _on_combo_failed():
	state_machine.transition_to("Collapsed")
	boss.active_combo.queue_free()
	
func get_active_action():
	return boss.active_combo.active_action
