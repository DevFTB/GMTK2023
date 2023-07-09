extends Node

var status = ""
var level = 0

var kill_words = ["KILLED", "DECIMATED", "MUTILATED", "DESTROYED"]
var boss_win_message = "You, %s, have %s the puny players"
var player_win_message = "You, %s, have been %s by the players"

# Called when the node enters the scene tree for the first time.
func _ready():
	status = "level"
#	enter_level(0)
	pass
	

func enter_level(n):
	status = "level"
	$CanvasLayer.visible = true
	$World.visible = true
	
	$Boss.global_position = Vector2(400, 400)
	$Boss.set_process(true)
	$Boss.reset()
	$Boss.visible = true
	
	$PlayerController.reset(n)

func setup_level(n):
	pass

func level_over(winner):
	if status == "level":
		status = "death screen"
		$Boss.set_process(false)
		
		$DeathScreen.visible = true
		$DeathScreen.get_node("DeathText").text = boss_win_message % [$Boss.boss_name, kill_words.pick_random()] if winner == "Boss" else player_win_message % [$Boss.boss_name, kill_words.pick_random()]
		$DeathScreen.get_node("DeathText").label_settings.font_size = 48 if len($DeathScreen.get_node("DeathText").text) < 250 else 32
		# todo: change to button?
		await get_tree().create_timer(3.0).timeout
		$DeathScreen.visible = false
		
		$PlayerController.clear_players()
		$World.visible = false
		$Boss.visible = false
		$CanvasLayer.visible = false
		
		enter_shop()

func enter_shop():
	status = "shop"
	$ActionComboScreenCanvasLayer.visible = true

func exit_shop():
	$ActionComboScreenCanvasLayer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_boss_boss_died():
	# todo - on kill players, next level of players walks on in
	level_over("Players")


func _on_player_controller_all_players_dead():
	level_over("Boss")
