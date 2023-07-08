extends Resource
class_name BossAction

@export var action_name :  String
@export var action_scene : PackedScene
@export var action_icon : Texture2D

## the beats it'll take to go from the start of the action to the damage point.
@export var amount_of_beats : int 

## the amount of beats after the damage point until the next action can be queued
@export var amount_of_cooldown_beats : int = 0
@export var is_hold_action : bool = false

func _init(p_action_name = "New Action", p_action_scene = null, p_action_icon = null, p_amount_of_beats = 1, p_amount_of_cooldown_beats = 0, p_hold_action = false):
	action_name  = p_action_name
	action_scene = p_action_scene
	action_icon = p_action_icon
	amount_of_beats = p_amount_of_beats
	amount_of_cooldown_beats = p_amount_of_cooldown_beats
	is_hold_action = p_hold_action
