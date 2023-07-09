extends Resource
class_name BossStats

signal level_changed()
signal gold_changed()

@export var base_health = 30
@export var level = 1
@export var level_scaling = 1.3
@export var base_level_gold_cost = 5.0
@export var health_per_level = 5
@export var starting_gold = 10:
	
	set(value):
		starting_gold = value
		gold = starting_gold

var gold = 0:
	set(value):
		gold = value
		gold_changed.emit()
		
func _init(p_level = 1, p_level_scaling = 1.3, p_base_level_gold_cost = 5.0, p_starting_gold = 1):
	level = p_level
	level_scaling = p_level_scaling
	base_level_gold_cost = p_base_level_gold_cost
	starting_gold = p_starting_gold

func get_level_cost() -> int:
	return round(pow(level_scaling, level) * base_level_gold_cost)
	
func level_up():
	if can_spend_gold(get_level_cost()):
		spend_gold(get_level_cost())
		level += 1
		level_changed.emit()
	pass

func add_gold(amnt: int):
	gold += amnt

func can_spend_gold(amnt: int):
	return gold >= amnt
	
func spend_gold(amnt: int):
	gold -= amnt

func get_health():
	return floor(base_health + health_per_level * pow(level_scaling, level))
