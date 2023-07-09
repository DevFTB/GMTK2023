extends Control

func _on_bin_binned(data):
	if data["type"] == "current":
		data["source"].clear()

