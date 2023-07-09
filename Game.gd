extends Node2D
	
var boss:
	get:
		return $Boss

var players_killed:
	get:
		return $PlayerController.get_child_count() - $PlayerController.get_players().size()

func disable_game():
	$BeatManager.stop()
	#process_mode = Node.PROCESS_MODE_DISABLED
	$GameOverlay.visible = false

func hide_game():
	visible = false	

func enable_game(level):
	#process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	$BeatManager.start()
	$GameOverlay.visible = true
	
		
	$Boss.global_position = Vector2(400, 400)
	$Boss.reset()
	
	$PlayerController.reset(level)

func hide_ui():
	$GameOverlay.visible = false
