extends "res://level/gui/DragVisibleControl.gd"

signal binned(data)

func _drop_data(at_position, data):
	binned.emit(data)
	pass
	
func _can_drop_data(at_position, data):
	return true
	
func _notification(what):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = true
	
	if what == NOTIFICATION_DRAG_END:
		visible = false
