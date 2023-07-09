extends Control

@onready var action_icons = get_tree().get_nodes_in_group("action_icon")

@onready var icon_rect = $MarginContainer/VBoxContainer/Control/TextureRect
@onready var description_label = $MarginContainer/VBoxContainer/RichTextLabel
@onready var buy_button = $MarginContainer/VBoxContainer/Button
func _ready():
	for ai in action_icons:
		ai.selected.connect(_on_action_icon_selected)
	pass

func _on_action_icon_selected(action : BossAction):
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
	
	print(description)
	
	description_label.text = description
	
	buy_button.visible = action.is_locked
	buy_button.text = "Cost " + str(action.gold_cost)
	
	
	pass
