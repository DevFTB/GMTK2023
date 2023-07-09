extends Control

const BossState = preload("res://entities/boss/BossState.gd")

@export var boss : Boss
@export var beat_manager : BeatManager



@onready var fg_color_rect = $BarArea/Bar/ForegroundColourRect
@onready var ball = $BarArea/Bar/Ball
@onready var left_warner = $LeftWarner
@onready var right_warner = $RightWarner

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
		ball.position.x = $BarArea/Bar.size.x * (fmod(beat_manager.timer, beat_manager.time_per_beat) / beat_manager.time_per_beat) - ball.size.x / 2
		pass
	else:
		# go left
		ball.position.x = $BarArea/Bar.size.x * (1 - (fmod(beat_manager.timer, beat_manager.time_per_beat) / beat_manager.time_per_beat)) - ball.size.x / 2
		pass

func _on_beat(beat_number):
	_update_gui()

func set_text(text: String):
	pass
var combo : ComboLifecycle

func _on_combo_started(clc: ComboLifecycle):
	self.combo = clc

	clc.failed.connect(fail)
	clc.completed.connect(clear_text)
	clc.action_hit.connect(_on_hit_action)
	set_alc(clc.active_action)
	
func _on_hit_action(action: BossAction, strength: float):
	if not combo.action_queue.is_empty():
		set_alc(combo.action_queue.front())
		print(alc.action.action_name, " giss")
	$BarArea/Control/HitLabel.display_hit_text(strength)
	
func set_alc(new_alc):
	alc = new_alc
	if alc != null:
		if alc.action.is_hold_action:
			alc.started.connect(func(): fg_color_rect.active = true)
			alc.hit.connect(func(x): fg_color_rect.active = false)
			assign_to_warner(alc.start_beat, true, true)
	
		assign_to_warner(alc.hit_beat, not alc.action.is_hold_action, alc.action.is_hold_action)
	_update_gui()

func assign_to_warner(beat: int, is_press, is_hold):
	if not beat % 2 == 0:
		$RightWarner.submit_input(beat, is_press, is_hold)
	else:
		$LeftWarner.submit_input(beat, is_press, is_hold)

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
	
func fail():
	clear_text()
	$LeftWarner.clear()
	$RightWarner.clear()
	$AnimationPlayer.play("fail_shake")
	
	pass
	
func clear_text():
	alc = null
	fg_color_rect.active = false
