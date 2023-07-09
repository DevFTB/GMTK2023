extends Control

@export var combo : Combo
@export var slot : int

func _ready():
	update_gui()

func _can_drop_data(at_position, data):
	return true

func _drop_data(at_position, data):
	combo.set_action(slot, data)
	update_gui()
	
func update_gui():
	if combo.actions.has(slot):
		var action = combo.actions[slot]
		$TextureRect.texture = action.action_icon
	pass
