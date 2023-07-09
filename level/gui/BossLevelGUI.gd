extends Control

@onready var health_label = $HBoxContainer/Label
@onready var upgrade_button = $HBoxContainer/Button

func _ready():
	owner.boss_stats.level_changed.connect(update_gui)
	owner.boss_stats.gold_changed.connect(update_gui)
	update_gui()


func update_gui():
	print("updating")
	var bs = owner.boss_stats
	health_label.text = "Health: %s" % str(bs.get_health())
	upgrade_button.text = "Level up for %s Gold" % str(bs.get_level_cost())
	upgrade_button.disabled = not bs.can_spend_gold(bs.get_level_cost())


func _on_button_pressed():
	owner.boss_stats.level_up()
	pass # Replace with function body.
