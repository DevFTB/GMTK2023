extends Resource
class_name Combo

# int (index) -> Action
@export var actions = {}
@export var amount_of_slots : int

func _init(p_actions = {}, p_amount_of_slots: int = 2):
	actions = p_actions
	amount_of_slots = p_amount_of_slots
	

func set_action(index: int, action: BossAction) -> void:
	if index < amount_of_slots and index > 0:
		actions[index] = action
		
func unset_action(index: int) -> void:
	if index < amount_of_slots and index > 0:
		actions.erase(index)


