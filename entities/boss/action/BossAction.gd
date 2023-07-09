extends Resource
class_name BossAction

@export var action_name :  String
@export var action_description : String

@export var action_scene : PackedScene
@export var action_icon : Texture2D

## the beats it'll take to go from the start of the action to the damage point.
@export var amount_of_beats : int 

## the amount of beats after the damage point until the next action can be queued
@export var amount_of_cooldown_beats : int = 0
@export var is_hold_action : bool = false

@export var starting_animation = ""
@export var sustain_animation = ""
@export var hit_animation = ""


@export var gold_cost = 1
@export var is_locked = true

@export var max_level = 3
@export var level = 1
@export var level_scaling = 2
@export var base_damage = 5

@export var upgrade_scaling = 1.5

@export var hit_sound : AudioStream

func _init(p_action_name = "New Action", p_action_scene = null, p_action_icon = null, p_amount_of_beats = 1, p_amount_of_cooldown_beats = 0, p_hold_action = false):
	action_name  = p_action_name
	action_scene = p_action_scene
	action_icon = p_action_icon
	amount_of_beats = p_amount_of_beats
	amount_of_cooldown_beats = p_amount_of_cooldown_beats
	is_hold_action = p_hold_action


func get_damage() -> int:
	print(base_damage, ", ", base_damage + (level - 1) * level_scaling )
	return base_damage + (level - 1) * level_scaling

func can_upgrade() -> bool :
	return level < max_level

func get_upgrade_cost():
	return round(pow(upgrade_scaling, level) * gold_cost)

func upgrade() -> void:
	if level < max_level:
		level += 1

func do_effect(_boss: Boss, _direction: Vector2):
	pass
