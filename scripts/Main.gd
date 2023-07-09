extends Node

var status = ""
var level = 0

var kill_words = ["KILLED", "DECIMATED", "MUTILATED", "DESTROYED"]
var boss_win_message = "You, %s, have %s the puny players"
var player_win_message = "You, %s, have been %s by the players"
var level_timer = 0
var level_damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	enter_level(level)
	

func enter_level(n):
	status = "level"
	$CanvasLayer.visible = true
	$World.visible = true
	
	$Boss.global_position = Vector2(400, 400)
	$Boss.set_process(true)
	$Boss.reset()
	$Boss.visible = true
	
	$PlayerController.reset(n)
	level_timer = 0
	level_damage = 0
	$BeatManager.start()

func setup_level(n):
	pass

func level_over(winner):
	if status == "level":
		status = "death screen"
		$Boss.set_process(false)
		
		var timer_gold = floor(level_timer/10)
		var players_killed = $PlayerController.get_child_count() - $PlayerController.get_players().size()
		var players_killed_gold = (10 + (2 * level)) * players_killed
		var clear_gold = (level+1) * 10 if winner == "Boss" else 0
		var total_gold_earned = timer_gold + players_killed_gold + clear_gold
		$Boss.boss_stats.add_gold(total_gold_earned)
		
		$DeathScreen.visible = true
		$DeathScreen.get_node("DeathText").text = boss_win_message % [$Boss.boss_name, kill_words.pick_random()] if winner == "Boss" else player_win_message % [$Boss.boss_name, kill_words.pick_random()]
		$DeathScreen.get_node("DeathText").text += "\n\n%s level %s players killed: %s gold" % [players_killed, level + 1, players_killed_gold]
		$DeathScreen.get_node("DeathText").text += "\n%s seconds survived: %s gold" % [floor(level_timer), timer_gold]
		if winner == "Boss":
			$DeathScreen.get_node("DeathText").text += "\nLevel %s cleared: %s gold" % [level + 1, clear_gold]
		$DeathScreen.get_node("DeathText").text += "\nTotal gold earned: %s gold" % [total_gold_earned]
		$DeathScreen.get_node("DeathText").label_settings.font_size = 48 if len($DeathScreen.get_node("DeathText").text) < 200 else 32
		# todo: change to button?
		if winner == "Boss":
			level += 1
		await get_node("DeathScreen/Button").pressed
		$DeathScreen.visible = false
		
		$PlayerController.clear_players()
		$World.visible = false
		$Boss.visible = false
		$CanvasLayer.visible = false
		
		enter_shop()

func enter_shop():
	$BeatManager.stop()
	status = "shop"
	$ActionComboScreenCanvasLayer.visible = true
	
	$IdleMusicPlayer.play()

func exit_shop():
	$ActionComboScreenCanvasLayer.visible = false
	$IdleMusicPlayer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if status == "level":
		level_timer += delta


func _on_boss_boss_died():
	# todo - on kill players, next level of players walks on in
	level_over("Players")


func _on_player_controller_all_players_dead():
	level_over("Boss")

func _on_combo_screen_start_button_pressed():
	exit_shop()
	enter_level(level)

