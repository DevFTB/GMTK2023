extends Control

const BossState = preload("res://entities/boss/BossState.gd")

@export var boss : Boss
@export var beat_manager : BeatManager

@onready var lbl = $LeftBeatLabel
@onready var rbl = $RightBeatLabel

var alc : ComboLifecycle.ActionLifecycle

func is_going_right():
	return beat_manager.beat_number % 2 == 0

func _ready():
	beat_manager.beat.connect(_on_beat)
	boss.started_combo.connect(_on_combo_started)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_going_right():
		# go right
		$Ball.position.x = $Bar.size.x * (fmod(beat_manager.timer, beat_manager.time_per_beat) / beat_manager.time_per_beat) - $Ball.size.x / 2
		pass
	else:
		# go left
		$Ball.position.x = $Bar.size.x * (1 - (fmod(beat_manager.timer, beat_manager.time_per_beat) / beat_manager.time_per_beat)) - $Ball.size.x / 2
		pass
	pass

func _on_beat(beat_number):
	_update_gui()

func set_text(text: String):
	if is_going_right():
		rbl.text = text
	else:
		lbl.text = text
var combo : ComboLifecycle

func _on_combo_started(clc: ComboLifecycle):
	self.combo = clc

	clc.failed.connect(func (): set_text(""))
	clc.completed.connect(func (): set_text(""))
	clc.hit_action.connect(_on_hit_action)
	alc = clc.active_action


func _on_hit_action():
	alc = combo.action_queue.front()
	
func _update_gui():
	var lbl_text = ""
	var rbl_text = ""
	
	if alc != null:
		if alc.action.is_hold_action:
			if alc.start_beat == beat_manager.beat_number + 1:
				set_text("Start Hold!")
			
			if alc.hit_beat == beat_manager.beat_number + 1:
				set_text("Release!")
		
		elif alc.hit_beat == beat_manager.beat_number + 1:
				set_text("Hit!")
		else:
			set_text("")
