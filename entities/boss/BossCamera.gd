extends Camera2D

var trauma = 0

@export var max_shake_power =4
@export var shake_time= 0.4

func _ready():
	randomize()
	pass
	
func _process(delta):
	if trauma > 0:
		_shake(delta)

func _shake(delta):
	var shake =  Vector2(randf(), randf())
	offset = shake * max_shake_power
	trauma -= shake.length()
	pass
	
func do_small_shake():
	trauma = 1

func do_large_shake():
	trauma = 3
