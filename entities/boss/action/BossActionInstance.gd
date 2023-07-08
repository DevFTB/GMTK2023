extends Node2D

@export var duration = 0.4

var strength = 1

func _ready():
	for child in $Hitboxes.get_children():
		child.damage *= strength

	get_tree().create_timer(duration).timeout.connect(queue_free)

