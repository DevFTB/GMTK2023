extends Control

@export var boss_stats : BossStats

func _on_action_detail_bought(action: BossAction):
	boss_stats.spend_gold(action.gold_cost)
	action.is_locked = false
	pass # Replace with function body.


func _on_action_detail_upgraded(action: BossAction):
	boss_stats.spend_gold(action.get_upgrade_cost())
	action.upgrade()
	pass # Replace with function body.
