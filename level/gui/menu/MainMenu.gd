extends Control


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.


func _on_htp_button_pressed():
	$Main.visible = false
	$HowToPlay.visible = true
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.



func _on_back_button_pressed():
	$HowToPlay.visible = false
	$Main.visible = true
	pass # Replace with function body.
