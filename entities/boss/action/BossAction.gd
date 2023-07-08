extends Resource
class_name BossAction

@export var action_name :  String
@export var action_scene : PackedScene
@export var action_icon : Texture2D
@export var amount_of_beats : int 

func _init(p_action_name = "New Action", p_action_scene = null, p_action_icon = null, p_amount_of_beats = 1):
	action_name  = p_action_name
	action_scene = p_action_scene
	action_icon = p_action_icon
	amount_of_beats = p_amount_of_beats
