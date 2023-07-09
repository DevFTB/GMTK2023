extends Control


func _on_control_3_binned(data):
	if data["type"] == "current":
		data["source"].clear()
	pass # Replace with function body.
