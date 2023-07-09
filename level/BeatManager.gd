extends Node
class_name BeatManager

@export var bpm = 155

signal beat(beat_number: int)

var beat_number = 1
var started = false
var timer = 0.0

var _target_beat = 1

@onready var time_per_beat = 60.0  / float(bpm)

func _ready():
	beat.connect(func (x): if beat_number % 1 == 0: print("beat ", beat_number))
	
	start()

func _process(delta):
	if started:
		timer += delta
	
		if timer > time_per_beat * beat_number:
			beat_number += 1
			beat.emit(beat_number)
	pass
func start():
	$AudioStreamPlayer.play()
	started = true
	
	beat_number = 1
	timer = 0.0
	_target_beat = 1
	pass
	
func stop():
	started = false
	$AudioStreamPlayer.stop()

func get_sync_amount(target_beat: int):
	var time_since_target_beat = abs(timer - time_per_beat * (target_beat))
	var distance = abs(1 - time_since_target_beat / time_per_beat)
	
	if distance < 0.5:
		return ease(1 - distance, 2)
	else:
		return 0

func get_beat_progress():
	return fmod(timer, time_per_beat) / time_per_beat
