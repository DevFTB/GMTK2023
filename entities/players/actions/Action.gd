extends Node

class_name Action

@export var action_range: int = 30
@export var cooldown: int = 10

var timer 

func _ready():
	timer = cooldown
	$ActionAnimation.visible = false
	
func _process(delta):
	timer = max(0, timer - delta)

func do(target):
	timer = cooldown
	$ActionAnimation.visible = true
#	$ActionAnimation.frame = 2
	$ActionAnimation.play()
#	print("doing " + self.name)

func off_cooldown():
	return timer == 0

func in_range(target):
	return (target.global_position - self.global_position).length() < action_range


func _on_action_animation_animation_finished():
#	pass
	$ActionAnimation.visible = false
#	$ActionAnimation.stop()
