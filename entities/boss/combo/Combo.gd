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


func generate_beat_action_map():
	var new_beat_action_map = {}
	var total_beats = 0
	for i in range(amount_of_slots ):
		var action = actions[i]
		total_beats += action.amount_of_beats

		new_beat_action_map[total_beats] = 0
		if action.is_hold_action:
			new_beat_action_map[total_beats + action.amount_of_beats] = 1
		total_beats += action.amount_of_cooldown_beats

	
	return new_beat_action_map
pass
