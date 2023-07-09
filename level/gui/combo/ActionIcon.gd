extends Control

signal selected(action:BossAction)

@export var action : BossAction

func _ready():
	update_gui()
	
func update_gui():
	$TextureRect.texture = action.action_icon
	$LockTextureRect.visible = action.is_locked
	pass
	
func _get_drag_data(at_position):
	var tr = TextureRect.new()
	tr.texture = action.action_icon
	tr.size = Vector2.ONE * 32
	set_drag_preview(tr)
	return { "action": action, "type": "new" }


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			selected.emit(action)
	pass # Replace with function body.
