extends ColorRect

@export var color_gradient : Gradient
@export var gradient_cycle_time : float

var timer = 0.0

var active = false:
	set(value):
		if not value:
			color = color_gradient.sample(0)
		else:
			timer = 0.0
		active = value

func _process(delta):
	if active:
		timer += delta
		
		var distance = fmod(timer, gradient_cycle_time) / gradient_cycle_time
		
		color = color_gradient.sample(distance)
