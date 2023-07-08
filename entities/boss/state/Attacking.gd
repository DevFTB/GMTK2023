extends "res://entities/boss/BossState.gd"

func enter():
	boss.active_combo.failed.connect(_on_combo_failed)
	boss.active_combo.completed.connect(_on_combo_completed)
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
