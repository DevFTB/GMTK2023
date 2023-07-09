extends Control

@onready var action_icons = get_tree().get_nodes_in_group("action_icons")

@onready var icon_rect = $MarginContainer/VBoxContainer/TextureRect
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
	buy_button.visible = action.is_locked
	pass
