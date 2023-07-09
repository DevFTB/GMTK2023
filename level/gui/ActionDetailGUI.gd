extends Control

@onready var action_icons = get_tree().get_nodes_in_group("action_icon")

@onready var icon_rect = $MarginContainer/VBoxContainer/Control/TextureRect
@onready var description_label = $MarginContainer/VBoxContainer/RichTextLabel
@onready var buy_button = $MarginContainer/VBoxContainer/BuyButton
@onready var upgrade_button = $MarginContainer/VBoxContainer/UpgradeButton

signal bought(action: Action)
signal upgraded(action: Action)

var current_action = null

func _ready():
	for ai in action_icons:
		ai.selected.connect(_on_action_icon_selected)
	pass

func _on_action_icon_selected(action : BossAction):
	current_action = action
	display_details(action)
	pass
	
func display_details(action: BossAction):
	icon_rect.texture = action.action_icon
	
	var format = """
	{name}
	{desc}
	Beats: {beats}, Cooldown: {cd}
	Damage: {dmg}
	"""
	
	var description=format.format({"name": action.action_name, "desc": action.action_description, "beats": action.amount_of_beats, "cd": action.amount_of_cooldown_beats, "dmg": action.get_damage()})
	
	description_label.text = description
	
	buy_button.visible = action.is_locked
	buy_button.text = "Buy for " + str(action.gold_cost) + " Gold"
	
	upgrade_button.visible = not action.is_locked and action.can_upgrade()
	upgrade_button.disabled = not owner.boss_stats.can_spend_gold(action.get_upgrade_cost())
	upgrade_button.text = "Upgrade for " + str(action.get_upgrade_cost()) + " Gold"
	
	pass


func _on_buy_button_pressed():
	bought.emit(current_action)
	display_details(current_action)
	
	for ai in action_icons:
		if ai.action == current_action:
			ai.update_gui()
	pass # Replace with function body.


func _on_upgrade_button_pressed():
	upgraded.emit(current_action)
	display_details(current_action)
	pass # Replace with function body.


func _on_bin_binned(data):
	pass # Replace with function body.
