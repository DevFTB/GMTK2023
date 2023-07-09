extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func health_changed(new_health, max_health, difference):
	$BossHealthBar.value = round((float(new_health)/max_health) * 100)
	
func name_changed(name):
	$BossName.text = name
	
	# set correct font size
	$BossName.label_settings.font_size=get_font_size(len(name))

func get_font_size(n_chars):
	if n_chars <= 40:
		return 24
	elif n_chars <= 60:
		return 16
	else:
		return 8

func _on_boss_boss_health_changed(new, max, difference):
	health_changed(new, max, difference)


func _on_boss_boss_name_changed(name):
	name_changed(name)
