extends Node
class_name State

@onready var state_machine = find_state_machine()

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func process_input(event: InputEvent) -> void:
	pass

func find_state_machine():
	var ancestor = get_parent()
	while ancestor != null and not ancestor is StateMachine:
		ancestor = ancestor.get_parent()
	return ancestor
