extends Control

func _notification(what):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = true
	
	if what == NOTIFICATION_DRAG_END:
		visible = false
