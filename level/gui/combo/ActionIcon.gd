extends Control

signal selected(action:BossAction)

@export var action : BossAction

func _ready():
	update_gui()
	
func update_gui():
	$TextureRect.texture = action.action_icon
	pass
	
func _get_drag_data(at_position):
	return action


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			selected.emit(action)
	pass # Replace with function body.
