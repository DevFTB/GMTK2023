extends Control

@export var from_left = true
@export var warner_scene : PackedScene
@export var beat_length = 4

@onready var beat_manager = get_tree().get_first_node_in_group("beat_manager")

func _ready():
	beat_manager.beat.connect(_on_beat)

func submit_input(beat: int, is_press: bool, is_hold: bool):
	var new_warner = warner_scene.instantiate()
	new_warner.set_input(beat, is_press, is_hold)
	$Spawn.add_child(new_warner)
	
	var seconds_per_beat = 60.0 / float(beat_manager.bpm)
	
	var beat_offset =beat - beat_manager.beat_number

	var time_remaining =  beat_manager.get_beat_progress() * beat_manager.time_per_beat
	
	var time_to_move = (beat_offset) * seconds_per_beat - time_remaining
	
	if from_left:
		new_warner.position.x = size.x - beat_offset * size.x / beat_length
		#new_warner.velocity = Vector2((position.x - size.x) / time_to_move , 0)
		new_warner.start_tween(size.x - new_warner.size.x / 2, time_to_move)
	else:
		new_warner.position.x = beat_offset * size.x / beat_length + new_warner.size.x / 2
		#new_warner.velocity = Vector2(-position.x / time_to_move, 0)
		new_warner.start_tween(0 - new_warner.size.x / 2, time_to_move)

func _on_beat(beat):
	for child in $Spawn.get_children():
		child.update_gui_for_beat(beat)
	pass

func clear():
	for c in $Spawn.get_children():
		c.queue_free()
