extends Control

@export var beat_manager : Node

@onready var lbl = $LeftBeatLabel
@onready var rbl = $RightBeatLabel

func _ready():
	beat_manager.beat.connect(_on_beat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if beat_manager.beat_number % 2 == 0:
		# go right
		$Ball.position.x = $Bar.size.x * (fmod(beat_manager.timer, beat_manager.time_per_beat) / beat_manager.time_per_beat) - $Ball.size.x / 2
		pass
	else:
		# go left
		$Ball.position.x = $Bar.size.x * (1 - (fmod(beat_manager.timer, beat_manager.time_per_beat) / beat_manager.time_per_beat)) - $Ball.size.x / 2
		pass
	pass

func _on_beat():
	var lbl_text = ""
	var rbl_text = ""
	
	if beat_manager.beat_subscriptions.has(beat_manager.beat_number + 1):
		if beat_manager.beat_number % 2 == 0:
			rbl_text = "HIT!!"
		else:
			lbl_text = "HIT!!"
	
	if beat_manager.beat_subscriptions.has(beat_manager.beat_number + 2):
		if beat_manager.beat_number % 2 == 1:
			rbl_text = "NEXT!!"
		else:
			lbl_text = "NEXT!!"
	
	rbl.text = rbl_text
	lbl.text = lbl_text
