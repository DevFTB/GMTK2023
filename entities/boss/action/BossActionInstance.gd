extends Node2D

@export var duration = 0.4

@export var stun_duration = 0.0
@export var slow_duration = 0.0
@export var knockback = 0.0

var strength = 1

func _ready():
	for child in $Hitboxes.get_children():
		child.damaged.connect(_on_player_damaged)
		child.damage *= strength

	get_tree().create_timer(duration).timeout.connect(queue_free)

func _on_player_damaged(player: Node2D):
	# apply effects
	pass
