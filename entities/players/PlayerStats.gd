extends Resource
class_name PlayerStats

@export var base_health = 10
@export var base_speed = 60
@export var base_ability_power = 1
@export var base_ability_cooldown = 3.0

@export var health_scaling = 1.5
@export var speed_scaling = 0.0
@export var ability_power_scaling = 1.5

# not implemented
@export var ability_cooldown_scaling = 1.0

# current value = base + scaling * level

func _init(p_base_health = 10, p_base_speed = 60, p_base_ability_power = 1, p_base_ability_cooldown = 3.0, p_health_scaling = 1.5, p_speed_scaling = 1.0, p_abiility_power_scaling = 1.5, p_ability_cooldown_scaling = 1.0):
	base_health = p_base_health
	base_speed = p_base_speed
	base_ability_power = p_base_ability_power
	base_ability_cooldown = p_base_ability_cooldown
	
	health_scaling = p_health_scaling
	speed_scaling = p_speed_scaling
	ability_power_scaling = p_abiility_power_scaling
	ability_cooldown_scaling = p_ability_cooldown_scaling
