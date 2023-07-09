extends Control
@export var combo_index = 0

@onready var boss = get_tree().get_first_node_in_group("boss")

@onready var timer = boss.combo_timers[combo_index]

func _ready():
	timer.timeout.connect(_on_timeout)
	update_gui()
	pass

func _process(delta):
	var cd = boss.get_combo_cooldown(combo_index)
	if cd > 0:
		$ProgressBar.ratio = boss.get_combo_cooldown(combo_index)
		$ProgressBar.modulate = Color.WHITE
	else:
		$ProgressBar.ratio = 1
	pass
	
func update_gui():
	$ProgressBar.modulate = Color.LIME_GREEN
	
func _on_timeout():
	update_gui()
