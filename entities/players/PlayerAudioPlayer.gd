extends AudioStreamPlayer2D

@export var speech_sound : AudioStream
@export var hurt_sound : AudioStream
@export var launch_sound : AudioStream

func play_sound(type: String):
	match type:
		"speech":
			stream = speech_sound
		"hurt":
			stream = hurt_sound
		"launch":
			stream = launch_sound
	
	play()
