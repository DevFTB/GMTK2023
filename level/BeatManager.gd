extends Node
class_name BeatManager

@export var bpm = 155

signal beat

var beat_number = 1
var started = false
var timer = 0.0

var _target_beat = 1

var beat_subscriptions = {}

@onready var time_per_beat = 60.0  / float(bpm)

func _ready():
	beat.connect(func (): if beat_number % 1 == 0: print("beat ", beat_number))
	
	start()

func _process(delta):
	if started:
		timer += delta
	
		if timer > time_per_beat * beat_number:
			# if it's time for the next beat, but the player didn't input anything when they were meant to this cleans up and fails them
			if beat_subscriptions.has(beat_number):
				print("goodbye try for ", beat_number)
				for sub in beat_subscriptions[beat_number]:
					sub.call(beat_number, 0)
				beat_subscriptions.erase(beat_number)
				var keys = beat_subscriptions.keys()
				if keys.size() > 0:
					keys.sort()
					_target_beat = keys[0]
			beat_number += 1
			beat.emit()
	pass

func _input(event):
	if event.is_action_pressed("rhythm_hit", true):
		if event.is_echo():
			print("holding")
	
	if event.is_action_released("rhythm_hit"):
		var sync = get_sync_amount(_target_beat)
		print("hit sync for beat ", _target_beat, ": ", sync)
		if beat_subscriptions.has(_target_beat):
			for sub in beat_subscriptions[_target_beat]:
				sub.call(_target_beat, sync)
			
			beat_subscriptions.erase(_target_beat)
		
		var keys = beat_subscriptions.keys()
		if keys.size() > 0:
			keys.sort()
			_target_beat = keys[0]
		
	if event.is_action_pressed("activate_combo_1"):
		subscribe_to_beats([4,6,8,12], func(_beat, sync): print("combo sync on beat ", _beat, " is ", sync))
		

func start():
	$AudioStreamPlayer.play()
	started = true
	pass

## beats should be ordered in ascending order
func subscribe_to_beats(beats : Array[int], cb: Callable) -> void:
	var current_beat = beat_number
	for b in beats:
		var actual_beat = b + current_beat
		if actual_beat <= beat_number:
			push_warning("tried to sub to beat ", b, " but current beat is ", beat_number)
		if beat_subscriptions.has(actual_beat):
			beat_subscriptions[actual_beat].append(cb)
		else:
			beat_subscriptions[actual_beat] = [cb]
		print("subscribed to beat: ", actual_beat)
	
	_target_beat = beats[0]
	pass

func get_sync_amount(target_beat: int):
	var time_since_target_beat = abs(timer - time_per_beat * (target_beat))
	var distance = abs(1 - time_since_target_beat / time_per_beat)
	
	if distance < 0.5:
		return ease(1 - distance, 2)
	else:
		return 0
