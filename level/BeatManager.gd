extends Node

@export var bpm = 155
signal beat

var beat_number = 1
var started = false
var timer = 0.0

@onready var time_per_beat = 60.0  / float(bpm)

func _ready():
	beat.connect(func (): if beat_number % 2 == 0: print("beat ", beat_number))
	
	start()

func _process(delta):
	if started:
		timer += delta
	
		if timer > time_per_beat:
			timer = 0.0
			beat_number += 1
			beat.emit()
	pass

func start():
	$AudioStreamPlayer.play()
	started = true
	pass
