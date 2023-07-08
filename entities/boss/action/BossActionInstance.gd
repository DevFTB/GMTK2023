extends Node2D

@export var duration = 0.4

var strength = 1

func _ready():
	$Hitbox.damage *= strength
	get_tree().create_timer(duration).timeout.connect(queue_free)

