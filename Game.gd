extends Node2D
	
var boss:
	get:
		return $Boss

var players_killed:
	get:
		return $PlayerController.get_child_count() - $PlayerController.get_players().size()

func disable_game():
	$BeatManager.stop()
	set_process(false)
	set_process_input(false)
	visible = false
	$GameOverlay.visible = false
	
func enable_game(level):
	set_process(true)
	set_process_input(true)
	visible = true
	$BeatManager.start()
	$GameOverlay.visible = true
	
		
	$Boss.global_position = Vector2(400, 400)
	$Boss.reset()
	
	$PlayerController.reset(level)

func hide_ui():
	$GameOverlay.visible = false
