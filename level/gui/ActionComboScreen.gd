extends Control

@export var boss_stats : BossStats

func _ready():
	var start_button = get_node("HBoxContainer/VBoxContainer/Control/HBoxContainer/Control2/MarginContainer/StartButton")
	start_button.button_down.connect(get_parent().get_parent()._on_combo_screen_start_button_pressed)
	boss_stats.gold_changed.connect(_on_gold_changed)

func _on_action_detail_bought(action: BossAction):
	boss_stats.spend_gold(action.gold_cost)
	action.is_locked = false
	pass # Replace with function body.


func _on_action_detail_upgraded(action: BossAction):
	boss_stats.spend_gold(action.get_upgrade_cost())
	action.upgrade()
	pass # Replace with function body.

func _on_gold_changed():
	get_node("HBoxContainer/VBoxContainer/Control/HBoxContainer/Control/MarginContainer/HBoxContainer/Money").text = str(boss_stats.gold)
