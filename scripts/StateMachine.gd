extends Node
class_name StateMachine

signal state_changed

signal state_entered(state)
signal state_exited(state)

@onready var active_state = get_child(0) as State

func _ready():
	active_state.enter()

func _process(delta):
	active_state.update(delta)
	pass

func _input(event):
	active_state.process_input(event)
	pass

func transition_to(state_name: String):
	await active_state.exit()
	state_exited.emit(active_state)
	
	active_state = get_node(state_name)
	
	active_state.enter()
	state_entered.emit(active_state)
	
	state_changed.emit()
	
	print("transitioned to state ", state_name)
