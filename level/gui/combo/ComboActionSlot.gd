extends Control

@export var combo : Combo
@export var slot : int

func _ready():
	combo.actions_updated.connect(update_gui)
	update_gui()

func _can_drop_data(at_position, data):
	return data["type"] == "new"

func _drop_data(at_position, data):
	combo.set_action(slot, data["action"])
	update_gui()
	
func update_gui():
	if combo.actions.has(slot):
		var action = combo.actions[slot]
		$TextureRect.texture = action.action_icon
	else:
		$TextureRect.texture = null
	pass
func _get_drag_data(at_position):
	if combo.actions.has(slot):
		var action = combo.actions[slot]
		$TextureRect.texture = action.action_icon
		var tr = TextureRect.new()
		tr.texture = action.action_icon
		tr.size = Vector2.ONE * 32
		set_drag_preview(tr)
		return { "action": action, "type": "current", "source": self }
	else:
		return null

func clear():
	combo.unset_action(slot)
	update_gui()
