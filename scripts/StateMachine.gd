extends Node
class_name StateMachine

signal state_changed

@onready var active_state = get_child(0) as State

func _process(delta):
	active_state.update(delta)
	pass

func _input(event):
	active_state.process_input(event)
	pass

func transition_to(state_name: String):
	await active_state.exit()
	
	active_state = get_node(state_name)
	
	active_state.enter()
	
	print("transitioned to state ", state_name)
